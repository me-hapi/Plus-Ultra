import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/virtual_consultation/user/ui/issue_row.dart';
import 'package:lingap/features/virtual_consultation/user/ui/professional_card.dart';

final searchProvider = StateProvider<String>((ref) => '');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchValue = ref.watch(searchProvider);

    final professionals = [
      {
        'name': 'Dr. Jane Doe',
        'availability': true,
        'location': 'Agoo',
        'distance': '1 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. John Smith',
        'availability': false,
        'location': 'San Fernando',
        'distance': '5 km',
        'job': 'Counselor'
      },
      {
        'name': 'Dr. Emily White',
        'availability': true,
        'location': 'Baguio City',
        'distance': '10 km',
        'job': 'Therapist'
      },
      {
        'name': 'Dr. Mark Green',
        'availability': false,
        'location': 'Vigan',
        'distance': '15 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. Sarah Black',
        'availability': true,
        'location': 'Dagupan',
        'distance': '8 km',
        'job': 'Counselor'
      },
      {
        'name': 'Dr. Robert Brown',
        'availability': true,
        'location': 'Alaminos',
        'distance': '12 km',
        'job': 'Therapist'
      },
      {
        'name': 'Dr. Olivia Blue',
        'availability': false,
        'location': 'Candon',
        'distance': '18 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. Liam Gray',
        'availability': true,
        'location': 'Urdaneta',
        'distance': '7 km',
        'job': 'Counselor'
      },
      {
        'name': 'Dr. Ava Silver',
        'availability': false,
        'location': 'Bauang',
        'distance': '4 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. Noah Gold',
        'availability': true,
        'location': 'San Juan',
        'distance': '2 km',
        'job': 'Therapist'
      },
      {
        'name': 'Dr. Mia Purple',
        'availability': true,
        'location': 'Pangasinan',
        'distance': '20 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. Ethan Coral',
        'availability': false,
        'location': 'La Union',
        'distance': '9 km',
        'job': 'Counselor'
      },
      {
        'name': 'Dr. Sophia Emerald',
        'availability': true,
        'location': 'Bangar',
        'distance': '3 km',
        'job': 'Therapist'
      },
      {
        'name': 'Dr. Logan Amber',
        'availability': false,
        'location': 'Narvacan',
        'distance': '25 km',
        'job': 'Psychologist'
      },
      {
        'name': 'Dr. Lily Ruby',
        'availability': true,
        'location': 'Pozorrubio',
        'distance': '6 km',
        'job': 'Counselor'
      },
    ].where((professional) {
      final name = professional['name'] as String;
      final matchesSearch = searchValue.isEmpty ||
          name.toLowerCase().contains(searchValue.toLowerCase());
      return matchesSearch;
    }).toList();

    final Map<String, String> issues = {
      "Stress": "assets/vitals/mood.png",
      "Anxiety": "assets/vitals/mood.png",
      "Depression": "assets/vitals/mood.png",
      "Relationship": "assets/vitals/mood.png",
      "Self-Esteem": "assets/vitals/mood.png",
      "Adjustment": "assets/vitals/mood.png",
      "Caregiving": "assets/vitals/mood.png",
      "Parenting": "assets/vitals/mood.png",
      "Career": "assets/vitals/mood.png",
      "Grief": "assets/vitals/mood.png",
      "Identity": "assets/vitals/mood.png",
      "Emotion": "assets/vitals/mood.png",
      "Resilience": "assets/vitals/mood.png",
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEBE7E4),
        title: const Text(
          'Find Therapist',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF473c38),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEBE7E4),
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
                  height: 40,
                  child: TextField(
                    key: const Key('search_bar'),
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                child: const Text(
                  'Browse by Issues',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF473c38),
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: IssuesRow(issues: issues),
              ),

              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Text(
                  'All Therapist',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF473c38),
                  ),
                ),
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
                            name: professional['name'] as String,
                            job: professional['job'] as String,
                            location: professional['location'] as String,
                            distance: professional['distance'] as String,
                            imageUrl: 'https://via.placeholder.com/150',
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
