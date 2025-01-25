import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
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
        backgroundColor: Colors.transparent,
        title: Text(
          'Appointment History',
          style: TextStyle(
              color: mindfulBrown['Brown80'],
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      backgroundColor: mindfulBrown['Brown10'],
      body: Column(
        children: [
          // Search Bar
          SizedBox(
            height: 8,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 65,
              child: TextField(
                key: const Key('search_bar'),
                decoration: InputDecoration(
                  hintText: 'Search...',
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
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 5),
                  ),
                  prefixIcon:
                      Icon(Icons.search, color: mindfulBrown['Brown80']),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: _appointments == null || _appointments!.isEmpty
                ? Center(
                    child: Text(
                      'No appointment history yet',
                      style: TextStyle(fontSize: 16, color: optimisticGray['Gray40']),
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
