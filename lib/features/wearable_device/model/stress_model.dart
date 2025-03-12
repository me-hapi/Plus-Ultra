import 'package:flutter/widgets.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/wearable_device/logic/stress_detection.dart';
import 'package:lingap/features/wearable_device/ui/stress_modal.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class StressModel {
  late Interpreter _interpreter;
  StressDetection stress = StressDetection();

  /// Accepts a callback that returns Future<void> when stress is detected.
  StressModel(Future<void> Function() onStressDetected, BuildContext context) {
    _loadModel(onStressDetected, context);
  }

  // Load the TFLite model from assets and run inference.
  Future<void> _loadModel(
      Future<void> Function() onStressDetected, BuildContext context) async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model3.tflite');

      final heartData = await stress.fetchHeartRateData(uid);

      // Validate heartData: if it's null or empty, throw an error.
      if (heartData == null || heartData.isEmpty) {
        throw Exception("Error: Heart data is empty.");
      }

      final stDev = stress.computeSD1SD2(heartData);
      final sd1 = stDev['SD1'];
      final sd2 = stDev['SD2'];
      final higuchi = stress.computeHiguchi(heartData);
      final sampen = stress.computeSampleEntropy(heartData);

      List<dynamic> testInput = [sd1, sd2, sampen, higuchi];
      // List<dynamic> testInput = [
      //   8.347897874,
      //   115.8624442,
      //   2.209659139,
      //   1.100714889
      // ];

      print('MODEL input: $testInput');
      final result = predict(testInput);
      print('Model loaded successfully');
      print('Prediction: $result');

      // If the prediction indicates stress, invoke the callback.
      if (result != 'no stress') {
        showStressDialog(context, onStressDetected);
      }
    } catch (e) {
      print('Error while loading the model: $e');
    }
  }

  // Runs inference using the TFLite model.
  String predict(List<dynamic> input) {
    // Create a 2D list for output with 1 row and 3 columns (as doubles)
    var output = List.generate(1, (_) => List.filled(3, 0.0));
    _interpreter.run(input, output);

    // Convert the output row to a List<double>
    List<double> predictions = output[0].cast<double>();

    // Find the index of the highest value in the predictions
    int maxIndex = 0;
    for (int i = 1; i < predictions.length; i++) {
      if (predictions[i] > predictions[maxIndex]) {
        maxIndex = i;
      }
    }

    // Map the indices to their corresponding labels
    Map<int, String> labels = {
      0: 'no stress',
      1: 'interruption',
      2: 'time pressure'
    };

    return labels[maxIndex] ?? 'unknown';
  }
}
