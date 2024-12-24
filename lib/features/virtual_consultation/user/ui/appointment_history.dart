import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/user/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/user/ui/appointment_card.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({Key? key}) : super(key: key);

  @override
  State<AppointmentHistory> createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  List<Map<String, dynamic>>? _appointments;
  String _searchQuery = '';
  final SupabaseDB supabase = SupabaseDB(client);

  @override
  void initState() {
    super.initState();
    setAppointmentHistory();
  }

  Future<void> setAppointmentHistory() async {
    // Fetch the appointment history asynchronously
    final fetchedAppointments = await supabase.fetchAppointmentHistory();

    // Update the state after fetching
    setState(() {
      _appointments = fetchedAppointments;
    });

    print(_appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment History'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search appointments...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: _appointments == null || _appointments!.isEmpty
                ? Center(
                    child: Text(
                      'No appointment history yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _appointments!.length,
                    itemBuilder: (context, index) {
                      final appointment = _appointments![index];

                      // Filter appointments based on search query
                      if (_searchQuery.isNotEmpty &&
                          !appointment['name']!
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }

                      return AppointmentCard(
                        imageUrl: appointment['imageUrl'] ?? '',
                        name: appointment['name'] ?? '',
                        dates: appointment['dates'] ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
