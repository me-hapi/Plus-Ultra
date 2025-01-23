import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            'Payment',
            style: TextStyle(
                  color: mindfulBrown['Brown80'],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            width: 200,
            color: Colors.grey[300], // Placeholder for QR code
            child: Center(
              child: Text(
                'QR Code Here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Divider(color: mindfulBrown['Brown30']),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session Fee',
                style: TextStyle(
                  color: optimisticGray['Gray50'],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'P 500',
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
}
