import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/virtual_consultation/ui/professional_card.dart';

final searchProvider = StateProvider<String>((ref) => '');
final sidebarVisibleProvider = StateProvider<bool>((ref) => false);

class ConsultationPage extends ConsumerWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchValue = ref.watch(searchProvider);
    final sidebarVisible = ref.watch(sidebarVisibleProvider);
    final searchController = TextEditingController();

    final professionals = [
      {'name': 'Dr. Jane Doe', 'availability': 'Available', 'job': 'Psychologist'},
      {'name': 'Dr. John Smith', 'availability': 'Not Available', 'job': 'Counselor'},
      {'name': 'Dr. Emily White', 'availability': 'Available', 'job': 'Therapist'},
      {'name': 'Dr. Mark Green', 'availability': 'Available Soon', 'job': 'Psychologist'},
    ].where((professional) {
      final matchesSearch = searchValue.isEmpty || professional['name']!.toLowerCase().contains(searchValue.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation Page')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Widget at the top with minimal margin
              Row(
                children: [
                  if (sidebarVisible)
                    // Placeholder for filter UI
                    Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar with Filter Button
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
                                    ref.read(searchProvider.notifier).state = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Filter Button
                              IconButton(
                                key: const Key('filter_button'),
                                icon: const Icon(Icons.filter_list),
                                onPressed: () {
                                  ref.read(sidebarVisibleProvider.notifier).state = !sidebarVisible;
                                },
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 6.0,
                          childAspectRatio: 0.65, // Adjusted to prevent overflow
                        ),
                        itemCount: professionals.length,
                        itemBuilder: (context, index) {
                          final professional = professionals[index];
                          return ProfessionalCard(
                            name: professional['name']!,
                            availability: professional['availability']!,
                            imageUrl: 'https://via.placeholder.com/150',
                            onSetAppointment: () {},
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
