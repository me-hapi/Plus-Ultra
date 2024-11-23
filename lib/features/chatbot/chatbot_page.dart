import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mediapipe_core/mediapipe_core.dart';
import 'package:mediapipe_text/mediapipe_text.dart';

final _log = Logger('ChatbotEmbedding');

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key, this.embedder});

  final TextEmbedder? embedder;

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage>
    with AutomaticKeepAliveClientMixin<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  List<EmbeddingFeedItem> feed = [];
  EmbeddingType type = EmbeddingType.quantized;
  bool l2Normalize = true;

  TextEmbedder? _embedder;
  Completer<TextEmbedder>? _completer;

  @override
  void initState() {
    super.initState();
    _controller.text = 'Enter text to embed';
    _initEmbedder();
  }

  @override
  void dispose() {
    final resultsIter =
        feed.where((el) => el._type == _EmbeddingFeedItemType.result);
    for (final feedItem in resultsIter) {
      feedItem.embeddingResult!.result?.dispose();
    }
    super.dispose();
  }

  Future<TextEmbedder> get embedder {
    if (widget.embedder != null) {
      return Future.value(widget.embedder!);
    }
    if (_completer == null) {
      _initEmbedder();
    }
    return _completer!.future;
  }

  Future<void> _initEmbedder() async {
    _embedder?.dispose();
    _completer = Completer<TextEmbedder>();

    ByteData? embedderBytes = await DefaultAssetBundle.of(context)
        .load('assets/universal_sentence_encoder.tflite');

    _embedder = TextEmbedder(
      TextEmbedderOptions.fromAssetBuffer(
        embedderBytes.buffer.asUint8List(),
        embedderOptions: EmbedderOptions(
          l2Normalize: l2Normalize,
          quantize: type == EmbeddingType.quantized,
        ),
      ),
    );
    _completer!.complete(_embedder);
    embedderBytes = null;
  }

  void _prepareForEmbedding() {
    setState(() {
      feed.add(
        EmbeddingFeedItem.result(
          TextWithEmbedding(
            computedAt: DateTime.now(),
            l2Normalized: l2Normalize,
            value: _controller.text,
          ),
        ),
      );
    });
  }

  void _showEmbeddingResults(TextEmbedderResult result) {
    setState(() {
      if (result.embeddings.isEmpty) return;

      feed.last = feed.last.complete(result);
    });
  }

  Future<void> _embed() async {
    _prepareForEmbedding();
    final embeddingResult = await (await embedder).embed(_controller.text);
    _showEmbeddingResults(embeddingResult);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Test Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(controller: _controller),
                ...feed.reversed.map<Widget>((feedItem) {
                  switch (feedItem._type) {
                    case _EmbeddingFeedItemType.result:
                      return TextEmbedderResultDisplay(
                        embeddedText: feedItem.embeddingResult!,
                        index: feed.indexOf(feedItem),
                      );
                    case _EmbeddingFeedItemType.comparison:
                      return ComparisonDisplay(
                          similarity: feedItem.similarity!);
                    case _EmbeddingFeedItemType.incomparable:
                      return const Text(
                          'Embeddings of different types cannot be compared');
                  }
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.text == '' ? null : _embed,
        child: const Icon(Icons.search),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Shows, in the activity feed, the results of invoking `cosineSimilarity`
/// between two [Embedding] objects (with identical metadata).
class ComparisonDisplay extends StatelessWidget {
  const ComparisonDisplay({super.key, required this.similarity});

  final double similarity;

  @override
  Widget build(BuildContext context) => Text('Similarity score: $similarity');
}

/// Shows, in the activity feed, a visualiation of an [Embedding] object.
class TextEmbedderResultDisplay extends StatelessWidget {
  const TextEmbedderResultDisplay({
    super.key,
    required this.embeddedText,
    required this.index,
  });

  final TextWithEmbedding embeddedText;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (embeddedText.result == null) {
      return const CircularProgressIndicator.adaptive();
    }
    final embedding = embeddedText.result!.embeddings.last;
    String embeddingDisplay = switch (embedding.type) {
      EmbeddingType.float => '${embedding.floatEmbedding!}',
      EmbeddingType.quantized => '${embedding.quantizedEmbedding!}',
    };
    // Replace "..." with the results
    return Card(
      key: Key('Embedding::"${embeddedText.value}" $index'),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('"${embeddedText.value}"',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(embeddingDisplay),
            Wrap(
              spacing: 4,
              children: <Widget>[
                if (embedding.type == EmbeddingType.float)
                  _embeddingAttribute('Float', Colors.blue[600]!),
                if (embedding.type == EmbeddingType.quantized)
                  _embeddingAttribute('Quantized', Colors.orange[600]!),
                if (embeddedText.l2Normalized)
                  _embeddingAttribute('L2 Normalized', Colors.green[600]!),
                _embeddingAttribute(embeddedText.computedAt.toIso8601String(),
                    Colors.grey[600]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _embeddingAttribute(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

/// Bundled [TextEmbeddingResult], the original text, and whether
/// that value was embedded with L2 normalization.
class TextWithEmbedding {
  const TextWithEmbedding._({
    required this.computedAt,
    required this.l2Normalized,
    required this.result,
    required this.value,
  });

  const TextWithEmbedding({
    required this.computedAt,
    required this.l2Normalized,
    required this.value,
  }) : result = null;

  final bool l2Normalized;
  final TextEmbedderResult? result;
  final String value;
  final DateTime computedAt;

  TextWithEmbedding complete(TextEmbedderResult result) => TextWithEmbedding._(
        computedAt: computedAt,
        l2Normalized: l2Normalized,
        result: result,
        value: value,
      );

  bool canComputeSimilarity(TextWithEmbedding other) =>
      result != null &&
      result!.embeddings.isNotEmpty &&
      other.result != null &&
      other.result!.embeddings.isNotEmpty &&
      l2Normalized == other.l2Normalized &&
      result!.embeddings.first.type == other.result!.embeddings.first.type;
}

/// Contains the various types of application state that can appear in the demo
/// app's activity feed.
class EmbeddingFeedItem {
  const EmbeddingFeedItem._({
    required this.similarity,
    required this.embeddingResult,
    required _EmbeddingFeedItemType type,
  }) : _type = type;

  factory EmbeddingFeedItem.comparison(double similarity) =>
      EmbeddingFeedItem._(
        similarity: similarity,
        embeddingResult: null,
        type: _EmbeddingFeedItemType.comparison,
      );

  factory EmbeddingFeedItem.result(TextWithEmbedding result) =>
      EmbeddingFeedItem._(
        similarity: null,
        embeddingResult: result,
        type: _EmbeddingFeedItemType.result,
      );

  EmbeddingFeedItem complete(TextEmbedderResult result) {
    assert(_type == _EmbeddingFeedItemType.result);
    return EmbeddingFeedItem.result(embeddingResult!.complete(result));
  }

  final TextWithEmbedding? embeddingResult;
  final double? similarity;
  final _EmbeddingFeedItemType _type;
}

enum _EmbeddingFeedItemType { result, comparison, incomparable }
