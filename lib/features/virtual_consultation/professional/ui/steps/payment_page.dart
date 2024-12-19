import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PaymentPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PaymentPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool? isFreeConsultation;
  File? _gcashQrImage;
  final TextEditingController consultationFeeController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void _triggerDataChanged() {
    widget.onDataChanged({
      'isFreeConsultation': isFreeConsultation,
      'consultationFee': consultationFeeController.text,
      'gcashQrImage': _gcashQrImage,
    });
  }

  @override
  void initState() {
    super.initState();
    consultationFeeController.addListener(_triggerDataChanged);
  }

  @override
  void dispose() {
    consultationFeeController.dispose();
    super.dispose();
  }

  // Function to pick or take an image
  Future<void> _pickImage() async {
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
                  await _processImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.pop(context);
                  await _processImage(ImageSource.camera);
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

  // Helper to process the image
  Future<void> _processImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(File(pickedFile.path));
      setState(() {
        _gcashQrImage = compressedImage;
        _triggerDataChanged();
      });
    }
  }

  // Function to build upload/display container
  Widget _buildImageContainer(String label, File? imageFile) {
    return GestureDetector(
      onTap: _pickImage,
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
                  'Upload $label',
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Do you offer free consultations?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isFreeConsultation = true;
                  _triggerDataChanged();
                });
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isFreeConsultation = false;
                  _triggerDataChanged();
                });
              },
              child: Text('No'),
            ),
          ],
        ),
        if (isFreeConsultation == false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: consultationFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Consultation Fee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (isFreeConsultation == false)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gcash QR',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        if (isFreeConsultation == false)
          _buildImageContainer('Gcash QR', _gcashQrImage),
      ],
    );
  }
}
