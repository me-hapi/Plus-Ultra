import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/logic/recommendation.dart';
import 'package:lingap/features/virtual_consultation/user/ui/appointment_history.dart';
import 'package:lingap/features/virtual_consultation/user/ui/issue_row.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';
import 'package:permission_handler/permission_handler.dart';

final searchProvider = StateProvider<String>((ref) => '');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Recommender recommender = Recommender();
  late TextEditingController searchController;
  SupabaseDB supabaseDB = SupabaseDB(client);
  List<Map<String, dynamic>> professionals = [];

  @override
  void initState() {
    super.initState();
    getUserLocation();
    searchController = TextEditingController();
    getProfessionals();
    recommender.recommendProfessional(userLat, userLong);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final Map<String, String> issues = {
    "Addiction": "assets/consultation/addiction.png",
    "Anxiety": "assets/consultation/anxiety.png",
    "Children": "assets/consultation/children.png",
    "Depression": "assets/consultation/depression.png",
    "Food": "assets/consultation/food.png",
    "Grief": "assets/consultation/grief.png",
    "LGBTQ": "assets/consultation/lgbtq.png",
    "Psychosis": "assets/consultation/psychosis.png",
    "Relationship": "assets/consultation/relationship.png",
    "Sleep": "assets/consultation/sleep.png",
  };

  void getProfessionals() async {
    List<Map<String, dynamic>> result = await supabaseDB.fetchProfessionals();
    setState(() {
      professionals = result;
      print(professionals);
    });
  }

  Future<void> getUserLocation() async {
    // Check location permission using permission_handler
    PermissionStatus status = await Permission.location.request();

    if (status.isDenied) {
      print("Location permission denied.");
      return;
    }

    if (status.isPermanentlyDenied) {
      print(
          "Location permission is permanently denied. Please enable it in settings.");
      openAppSettings(); // Opens app settings to manually enable location
      return;
    }

    if (status.isGranted) {
      // Get current position using geolocator
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      setState(() {
        userLat = position.latitude;
        userLong = position.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchValue = ref.watch(searchProvider);

    professionals.where((professional) {
      final name = professional['name'] as String;
      final matchesSearch = searchValue.isEmpty ||
          name.toLowerCase().contains(searchValue.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF473c38),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text(
          'Find Therapist',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: mindfulBrown["Brown80"]),
        ),
        centerTitle: true, // Centers the title
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: mindfulBrown["Brown80"]),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentHistory()));
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 65,
                  child: TextField(
                    key: const Key('search_bar'),
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: mindfulBrown['Brown80'],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        borderSide: BorderSide(
                            color: serenityGreen['Green30']!,
                            width: 3), // Light green border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 5),
                      ),
                      prefixIcon:
                          Icon(Icons.search, color: mindfulBrown['Brown80']),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).state = value;
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Browse by Issues',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: mindfulBrown['Brown80']),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: IssuesRow(issues: issues),
              ),

              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'All Therapist',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: mindfulBrown['Brown80'],
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              professionals.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: professionals.map((professional) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 0), // Reduce horizontal padding
                          child: ProfessionalCard(
                            professionalData: professional,
                          ),
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text(
                        'No professionals found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
