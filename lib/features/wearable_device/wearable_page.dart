import 'package:flutter/material.dart';

class WearableTechPage extends StatefulWidget {
  const WearableTechPage({Key? key}) : super(key: key);

  @override
  _WearableTechPageState createState() => _WearableTechPageState();
}

class _WearableTechPageState extends State<WearableTechPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wearable Tech Page')),
      body: Center(child: Text('This is a placeholder for the Wearable Tech Page')),
    );
  }
}