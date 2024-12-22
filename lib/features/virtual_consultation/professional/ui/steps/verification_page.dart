import 'package:flutter/material.dart';
import 'dart:io';
import 'package:lingap/features/virtual_consultation/professional/logic/verification_logic.dart';

class VerificationPage extends StatefulWidget {
  final Function(Map<String, File?>) onDataChanged;

  const VerificationPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late VerificationLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = VerificationLogic(onDataChanged: (data) {
      setState(() {});
      widget.onDataChanged(data);
    });
  }

  Widget _buildImageContainer(String label, File? imageFile, bool isFront) {
    return GestureDetector(
      onTap: () async {
        await _logic.pickImage(context, isFront);
      },
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey, width: 2),
          color: Colors.grey[200],
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Text(
                  'Upload $label ID',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _buildImageContainer('Front', _logic.frontImage, true),
        _buildImageContainer('Back', _logic.backImage, false),
      ],
    );
  }
}
