import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      {'name': 'Dr. Jane Doe', 'availability': true, 'job': 'Psychologist'},
      {'name': 'Dr. John Smith', 'availability': false, 'job': 'Counselor'},
      {'name': 'Dr. Emily White', 'availability': true, 'job': 'Therapist'},
      {'name': 'Dr. Mark Green', 'availability': false, 'job': 'Psychologist'},
      {'name': 'Dr. Sarah Black', 'availability': true, 'job': 'Counselor'},
      {'name': 'Dr. Robert Brown', 'availability': true, 'job': 'Therapist'},
      {'name': 'Dr. Olivia Blue', 'availability': false, 'job': 'Psychologist'},
      {'name': 'Dr. Liam Gray', 'availability': true, 'job': 'Counselor'},
      {'name': 'Dr. Ava Silver', 'availability': false, 'job': 'Psychologist'},
      {'name': 'Dr. Noah Gold', 'availability': true, 'job': 'Therapist'},
    ].where((professional) {
      final name = professional['name'] as String;
      final matchesSearch = searchValue.isEmpty ||
          name.toLowerCase().contains(searchValue.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Widget at the top with minimal margin
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  key: const Key('search_bar'),
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Search by Name',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    ref.read(searchProvider.notifier).state =
                                        value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Professional List
              professionals.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 6.0,
                                childAspectRatio: 0.8),
                        itemCount: professionals.length,
                        itemBuilder: (context, index) {
                          final professional = professionals[index];
                          return ProfessionalCard(
                            name: professional['name'] as String,
                            availability: professional['availability'] as bool,
                            job: professional['job'] as String,
                            imageUrl: 'https://via.placeholder.com/150',
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text(
                          'No professionals found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
