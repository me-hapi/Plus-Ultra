import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/virtual_consultation/professional/logic/clinicLogic.dart';

class ClinicPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const ClinicPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _ClinicPageState createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  final MapController mapController = MapController();
  final MapController mapController2 = MapController();
  bool showAdditionalFields = false;
  String? clinicName;
  String? clinicAddress;
  LatLng? selectedLocation;
  TextEditingController searchLocation = TextEditingController();
  List<dynamic> locations = [];
  final ClinicLogic clinicLogic = ClinicLogic();
  LatLng defaultLocation = LatLng(14.6372059, 121.0422091);

  Future<void> fetchLocations(String query) async {
    if (query.isEmpty) {
      setState(() {
        locations = [];
      });
      return;
    }
    // Call your geocode logic here
    List<dynamic> result = await clinicLogic.geocode(query);
    setState(() {
      locations = result;
    });
  }

  void _triggerDataChanged() {
    widget.onDataChanged({
      'teleconsultationOnly': !showAdditionalFields,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'selectedLocation': selectedLocation != null
          ? {
              'lat': selectedLocation!.latitude,
              'lng': selectedLocation!.longitude
            }
          : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
          16.0), // Add consistent padding around the column
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the left
        children: [
          Text(
            'Do you offer teleconsultation only?',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mindfulBrown['Brown80']),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAdditionalFields = false;
                    _triggerDataChanged();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: showAdditionalFields
                        ? Colors.white
                        : serenityGreen['Green50'],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: showAdditionalFields
                          ? mindfulBrown['Brown80']
                          : Colors.white,
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
                    showAdditionalFields = true;
                    _triggerDataChanged();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: showAdditionalFields
                        ? serenityGreen['Green50']
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: showAdditionalFields
                          ? Colors.white
                          : mindfulBrown['Brown80'],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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

            TextFormField(
              onChanged: (value) {
                setState(() {
                  clinicName = value;
                  _triggerDataChanged();
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter Clinic Name',
                fillColor: Colors.white, // Background fill color
                filled: true, // Enable the fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide.none, // No default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide(
                    color:
                        serenityGreen['Green50']!, // Green border when focused
                    width: 2.0, // Width of the border
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ), // Adjust padding for better appearance
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Clinic Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),

            TextFormField(
              onChanged: (value) {
                setState(() {
                  clinicAddress = value;
                  _triggerDataChanged();
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter Clinic address',
                fillColor: Colors.white, // Background fill color
                filled: true, // Enable the fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide.none, // No default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide(
                    color:
                        serenityGreen['Green50']!, // Green border when focused
                    width: 2.0, // Width of the border
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ), // Adjust padding for better appearance
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
                  backgroundColor: mindfulBrown['Brown10'],
                  isScrollControlled: true,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, StateSetter modalSetState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: searchLocation,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () async {
                                      await fetchLocations(searchLocation.text);

                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                  hintText: 'Search location',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.green,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: FlutterMap(
                                        mapController: mapController,
                                        options: MapOptions(
                                          initialCenter: selectedLocation ??
                                              defaultLocation,
                                          initialZoom: 16,
                                          onPositionChanged: (position, _) {
                                            setState(() {
                                              selectedLocation =
                                                  position.center!;
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
                                    Center(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 36.0,
                                        color: presentRed['Red50'],
                                      ),
                                    ),
                                    if (locations.isNotEmpty)
                                      Positioned(
                                        key: ValueKey(locations.length),
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                200, // Limit the height of the suggestion box
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: locations.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(locations[index]
                                                    ['display_name']),
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();

                                                  modalSetState(() {
                                                    selectedLocation = LatLng(
                                                        double.parse(
                                                            locations[index]
                                                                ['lat']),
                                                        double.parse(
                                                            locations[index]
                                                                ['lon']));

                                                    locations = [];
                                                  });

                                                  mapController.move(
                                                      selectedLocation!, 18.0);
                                                  mapController2.move(
                                                      selectedLocation!, 18.0);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 55,
                              width: 170,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextButton(
                                  onPressed: () {
                                    _triggerDataChanged();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: serenityGreen['Green50'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: mindfulBrown['Brown80']!, width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController2,
                        options: MapOptions(
                          initialCenter: selectedLocation ?? defaultLocation,
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
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  'Tap to select location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ))),
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
