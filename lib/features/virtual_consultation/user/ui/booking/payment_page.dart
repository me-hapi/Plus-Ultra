import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';

class PaymentPage extends StatelessWidget {
  final String qr_code;
  final int fee;
  final ScreenshotController screenshotController = ScreenshotController();

  PaymentPage({Key? key, required this.qr_code, required this.fee})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          if (fee != 0)
            Text(
              'Scan this QR code for your payment',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 24),
          if (fee != 0) _buildImageContainer(qr_code),
          SizedBox(height: 16),
          if (fee != 0) _buildDownloadButton(context),
          SizedBox(height: 32),
          Divider(color: mindfulBrown['Brown30']),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Fee',
                style: TextStyle(
                  color: mindfulBrown['Brown80'],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                fee == 0 ? 'Free' : '₱ ${fee}.00',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: mindfulBrown['Brown80'],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(String qr) {
    return Screenshot(
      controller: screenshotController,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: QrImageView(
              data: qr,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  Widget _buildDownloadButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _requestStoragePermission(); // Request storage permission

        if (await Permission.storage.isGranted ||
            await Permission.manageExternalStorage.isGranted) {
          final directory = Directory('/storage/emulated/0/Download');
          final filePath = '${directory.path}/qr_code.png';
          final Uint8List? image = await screenshotController.capture();

          if (image != null) {
            final file = File(filePath);
            await file.writeAsBytes(image);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('QR Code downloaded to Downloads folder')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Storage permission is required to download QR Code.')),
          );
        }
      },
      child: Text('Download QR Code'),
    );
  }
}
