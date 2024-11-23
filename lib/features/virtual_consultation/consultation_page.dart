import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingap/features/virtual_consultation/ui/professional_card.dart';
import 'package:lingap/features/virtual_consultation/ui/search_filter.dart';

final searchProvider = StateProvider<String>((ref) => '');
final availabilityProvider = StateProvider<String>((ref) => 'All');
final jobProvider = StateProvider<String>((ref) => 'All');
final sortByProvider = StateProvider<String>((ref) => 'Name');

class ConsultationPage extends ConsumerWidget {
  const ConsultationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAvailability = ref.watch(availabilityProvider);
    final selectedJob = ref.watch(jobProvider);
    final sortBy = ref.watch(sortByProvider);
    final searchValue = ref.watch(searchProvider);

    final professionals = [
      {'name': 'Dr. Jane Doe', 'availability': 'Available', 'job': 'Psychologist'},
      {'name': 'Dr. John Smith', 'availability': 'Not Available', 'job': 'Counselor'},
      {'name': 'Dr. Emily White', 'availability': 'Available', 'job': 'Therapist'},
      {'name': 'Dr. Mark Green', 'availability': 'Available Soon', 'job': 'Psychologist'},
    ].where((professional) {
      final matchesSearch = searchValue.isEmpty || professional['name']!.toLowerCase().contains(searchValue.toLowerCase());
      final matchesAvailability = selectedAvailability == 'All' || professional['availability'] == selectedAvailability;
      final matchesJob = selectedJob == 'All' || professional['job'] == selectedJob;
      return matchesSearch && matchesAvailability && matchesJob;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Consultation Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Filter Widget
            ProfessionalSearchAndFilter(),
            const SizedBox(height: 16),
            // Professional List
            Expanded(
              child: professionals.isNotEmpty
                  ? ListView(
                      children: professionals.map((professional) {
                        return ProfessionalCard(
                          name: professional['name']!,
                          availability: professional['availability']!,
                          imageUrl: 'https://via.placeholder.com/150',
                          onSetAppointment: () {},
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Text(
                        'No professionals found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
