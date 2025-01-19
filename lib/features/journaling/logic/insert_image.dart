import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class InsertImage extends StatefulWidget {
  final Function(File) onImageInserted;

  InsertImage({required this.onImageInserted});

  @override
  _InsertImageState createState() => _InsertImageState();
}

class _InsertImageState extends State<InsertImage> {
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _showImageSourceOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    final compressedImage =
                        await _compressImage(File(image.path));
                    if (compressedImage != null) {
                      widget.onImageInserted(compressedImage);
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.photo, size: 24),
                    SizedBox(width: 16),
                    Text('Pick from Gallery', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    final compressedImage =
                        await _compressImage(File(image.path));
                    if (compressedImage != null) {
                      widget.onImageInserted(compressedImage);
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, size: 24),
                    SizedBox(width: 16),
                    Text('Capture with Camera', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(), // Ensures the button is circular
      backgroundColor: Colors.white, // Sets the background color to white
      elevation: 0, // No shadow
      heroTag: 'camera_button',
      onPressed: () => _showImageSourceOptions(context),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Image.asset('assets/journal/camera.png'),
      ),
    );
  }
}
