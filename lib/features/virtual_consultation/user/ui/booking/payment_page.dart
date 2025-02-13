import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatelessWidget {
  final String qr_code;
  final int fee;

  const PaymentPage({Key? key, required this.qr_code, required this.fee})
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
              'Payment',
              style: TextStyle(
                color: mindfulBrown['Brown80'],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: 24),
          if (fee != 0) _buildImageContainer(qr_code),
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
                fee == 0 ? 'Free' : 'P $fee',
                style: TextStyle(
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
    return Center(
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
            )));
  }
}
