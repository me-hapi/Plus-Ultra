import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateProvider<String>((ref) => '');
final sidebarVisibleProvider = StateProvider<bool>((ref) => false);

class SearchAndSidebar extends ConsumerWidget {
  const SearchAndSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
    final sidebarVisible = ref.watch(sidebarVisibleProvider);

    return Row(
      children: [
        // Sidebar
        if (sidebarVisible)
          Container(
            width: 250,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Here you can add filter options, e.g., dropdowns or checkboxes
                  // For now, placeholder text
                  Text('Filter options go here'),
                ],
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
    );
  }
}
