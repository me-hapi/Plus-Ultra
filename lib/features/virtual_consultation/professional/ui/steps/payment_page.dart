import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const PaymentPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool? isFreeConsultation;
  File? _gcashQrImage;
  String? _decodedQR;
  final TextEditingController consultationFeeController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final decoder = QRCodeDartScanDecoder(
    formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.aztec,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.pdf417,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.code128,
      BarcodeFormat.ean8,
      BarcodeFormat.ean13,
    ],
  );

  void _triggerDataChanged() {
    widget.onDataChanged({
      'isFreeConsultation': isFreeConsultation,
      'consultationFee': consultationFeeController.text,
      'gcashQr': _decodedQR,
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
    // if (pickedFile != null) {
    //   final compressedImage = await _compressImage(File(pickedFile.path));
    //   setState(() {
    //     _gcashQrImage = compressedImage;
    //     _triggerDataChanged();
    //   });
    // }
    if (pickedFile != null) {
      try {
        Result? result = await decoder.decodeFile(pickedFile);
        String? qrCodeData = result.toString();
        setState(() {
          _decodedQR = qrCodeData;
        });
      } catch (e) {
        setState(() {
          _decodedQR = "Failed to decode QR code.";
        });
      }
    }
  }

  // Function to build upload/display container
  Widget _buildImageContainer(String label, File? imageFile) {
    return GestureDetector(
        onTap: _pickImage,
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: mindfulBrown['Brown80']!, width: 2),
              color: Colors.white,
            ),
            child: _decodedQR != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: QrImageView(
                      data: _decodedQR!,
                      version: QrVersions.auto,
                      size: 300.0,
                    ),
                  )
                : Center(
                    child: Text(
                      _decodedQR ?? 'Upload',
                      style: TextStyle(fontSize: 16, color: mindfulBrown['Brown80']),
                    ),
                  ),
          ),
        ));
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
            style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFreeConsultation = true;
                  _triggerDataChanged();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isFreeConsultation != null
                      ? isFreeConsultation!
                          ? serenityGreen['Green50']
                          : Colors.white
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: isFreeConsultation != null
                        ? isFreeConsultation!
                            ? Colors.white
                            : mindfulBrown['Brown80']
                        : mindfulBrown['Brown80'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFreeConsultation = false;
                  _triggerDataChanged();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isFreeConsultation != null
                      ? !isFreeConsultation!
                          ? serenityGreen['Green50']
                          : Colors.white
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                child: Text(
                  'No',
                  style: TextStyle(
                    color: isFreeConsultation != null
                        ? !isFreeConsultation!
                            ? Colors.white
                            : mindfulBrown['Brown80']
                        : mindfulBrown['Brown80'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isFreeConsultation == false)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: 
            TextFormField(
              controller: consultationFeeController,
                decoration: InputDecoration(
                  hintText: 'Consultation Fee',
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide(
                      color: serenityGreen[
                          'Green50']!, // Green border when focused
                      width: 2.0, // Width of the border
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Adjust padding for better appearance
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
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
