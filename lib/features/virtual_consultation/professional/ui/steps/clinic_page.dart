import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ClinicPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const ClinicPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  bool showAdditionalFields = false;
  String? clinicName;
  String? clinicAddress;
  LatLng? selectedLocation;

  void _triggerDataChanged() {
    widget.onDataChanged({
      'teleconsultationOnly': !showAdditionalFields,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'selectedLocation': selectedLocation != null
          ? {'lat': selectedLocation!.latitude, 'lng': selectedLocation!.longitude}
          : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add consistent padding around the column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
        children: [
          SizedBox(height: 20), // Add padding at the top
          Text(
            'Teleconsultation only',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showAdditionalFields = false;
                    _triggerDataChanged();
                  });
                },
                child: Text('Yes'),
              ),
              SizedBox(width: 20), // Add spacing between buttons
              TextButton(
                onPressed: () {
                  setState(() {
                    showAdditionalFields = true;
                    _triggerDataChanged();
                  });
                },
                child: Text('No'),
              ),
            ],
          ),
          if (showAdditionalFields) ...[
            SizedBox(height: 5), // Add spacing between sections
            Text(
              'Clinic Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  clinicName = value;
                  _triggerDataChanged();
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter clinic name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Clinic Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  clinicAddress = value;
                  _triggerDataChanged();
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter clinic address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Search Location',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(51.5, -0.09), // Example coordinates
                                initialZoom: 13.0,
                                onTap: (tapPosition, point) {
                                  setState(() {
                                    selectedLocation = point;
                                    _triggerDataChanged();
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c'],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(51.5, -0.09), // Example coordinates
                          initialZoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          'Tap to select location',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
