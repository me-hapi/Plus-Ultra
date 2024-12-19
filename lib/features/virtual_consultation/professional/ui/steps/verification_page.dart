import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class VerificationPage extends StatefulWidget {
  final Function(Map<String, File?>) onDataChanged;

  const VerificationPage({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  File? _frontImage;
  File? _backImage;

  final ImagePicker _picker = ImagePicker();

  // Function to pick or take an image
  Future<void> _pickImage(bool isFront) async {
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
                  await _processImage(ImageSource.gallery, isFront);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(ImageSource.camera, isFront);
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
      minWidth: 800, // Adjust based on your needs
      minHeight: 800, // Adjust based on your needs
      quality:
          85, 
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

  Future<void> _processImage(ImageSource source, bool isFront) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      final compressedImage = await _compressImage(imageFile);

      if (compressedImage != null) {
        setState(() {
          if (isFront) {
            _frontImage = compressedImage;
          } else {
            _backImage = compressedImage;
          }
        });

        if (_frontImage != null && _backImage != null) {
          widget.onDataChanged({
            'frontImage': _frontImage!,
            'backImage': _backImage!,
          });
        }
      } else {
        // Handle compression error (e.g., show a message to the user)
        print('Error compressing the image');
      }
    }
  }

  // Function to build upload/display rectangles
  Widget _buildImageContainer(String label, File? imageFile, bool isFront) {
    return GestureDetector(
      onTap: () => _pickImage(isFront),
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
        _buildImageContainer('Front', _frontImage, true),
        _buildImageContainer('Back', _backImage, false),
      ],
    );
  }
}
