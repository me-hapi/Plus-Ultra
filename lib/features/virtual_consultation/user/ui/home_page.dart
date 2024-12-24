import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/appointment_history.dart';
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
  SupabaseDB supabaseDB = SupabaseDB(client);
  List<Map<String, dynamic>> professionals = [];

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getProfessionals();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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

  void getProfessionals() async {
    List<Map<String, dynamic>> result = await supabaseDB.fetchProfessionals();
    setState(() {
      professionals = result;
    });
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
        backgroundColor: const Color(0xFFEBE7E4),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF473c38),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Find Therapist',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF473c38),
          ),
        ),
        centerTitle: true, // Centers the title
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history, // Icon for appointment history
              color: Color(0xFF473c38),
            ),
            iconSize: 30.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => AppointmentHistory()));
            },
          ),
        ],
        automaticallyImplyLeading:
            false, // Removes the back button from the AppBar
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

              SizedBox(
                height: 16,
              ),
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
