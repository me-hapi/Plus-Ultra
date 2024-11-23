import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateProvider<String>((ref) => '');
final availabilityProvider = StateProvider<String>((ref) => 'All');
final jobProvider = StateProvider<String>((ref) => 'All');
final sortByProvider = StateProvider<String>((ref) => 'Name');

class ProfessionalSearchAndFilter extends ConsumerWidget {
  const ProfessionalSearchAndFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
    final selectedAvailability = ref.watch(availabilityProvider);
    final selectedJob = ref.watch(jobProvider);
    final sortBy = ref.watch(sortByProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search & Filter Professionals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              key: Key('search_bar'),
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Availability Filter
                DropdownButton<String>(
                  key: Key('availability_filter'),
                  value: selectedAvailability,
                  items: ['All', 'Available', 'Not Available', 'Available Soon']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(availabilityProvider.notifier).state = value!;
                  },
                ),
                // Job Filter
                DropdownButton<String>(
                  key: Key('job_filter'),
                  value: selectedJob,
                  items: ['All', 'Psychologist', 'Counselor', 'Therapist']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(jobProvider.notifier).state = value!;
                  },
                ),
                // Sort By
                DropdownButton<String>(
                  key: Key('sort_by_filter'),
                  value: sortBy,
                  items: ['Name', 'Job']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Sort by $value'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    ref.read(sortByProvider.notifier).state = value!;
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for Professional List
            Expanded(
              child: Center(
                child: Text(
                  'Professionals will be displayed here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
