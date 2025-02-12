import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class InformationLogic {
  final Function(Map<String, File?>) onDataChanged;
  final ImagePicker _picker = ImagePicker();

  File? _frontImage;

  InformationLogic({required this.onDataChanged});

  File? get frontImage => _frontImage;

  void updateFrontImage(File image) {
    _frontImage = image;
    _notifyChanges();
  }

  void _notifyChanges() {
    onDataChanged({
      'profile': _frontImage,
    });
  }

  Future<void> pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _compressImage(File imageFile) async {
    final compressedFile = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800,
      minHeight: 800,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) return null;

    final compressedImageFile = File('${imageFile.path}_compressed.jpg');
    await compressedImageFile.writeAsBytes(compressedFile);

    if (compressedImageFile.lengthSync() > 1000000) {
      return _compressImage(compressedImageFile);
    }

    return compressedImageFile;
  }

  Future<void> _processImage(BuildContext context, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      updateFrontImage(imageFile);

      final compressedImage = await _compressImage(imageFile);

      if (compressedImage != null) {
        updateFrontImage(compressedImage);
      } else {
        print('Error compressing the image');
      }
    }
  }
}
