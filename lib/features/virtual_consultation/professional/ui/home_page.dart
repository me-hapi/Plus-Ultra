import 'package:flutter/material.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/professional/data/supabase_db.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/appointment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final SupabaseDB supabase = SupabaseDB(client);
  late TabController _tabController;
  late Map<String, List<Map<String, dynamic>>> appointments = {
    'pending': [],
    'approved': [],
    'completed': []
  };

  @override
  void initState() {
    super.initState();
    fetchAppointments();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchAppointments() async {
    final result = await supabase.fetchAppointments(uid);
    print(result);
    setState(() {
      appointments = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to profile page or show profile dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile picture clicked')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // Replace with actual profile image URL
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAppointmentList(
              appointments['pending']!.cast<Map<String, dynamic>>(),
              'No pending appointments yet'),
          buildAppointmentList(
              appointments['approved']!.cast<Map<String, dynamic>>(),
              'No approved appointments yet'),
          buildAppointmentList(
              appointments['completed']!.cast<Map<String, dynamic>>(),
              'No completed appointments yet'),
        ],
      ),
    );
  }

  Widget buildAppointmentList(
      List<Map<String, dynamic>>? appointments, String emptyMessage) {
    if (appointments == null || appointments.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(
          name: appointment['full_name']!,
          date: appointment['appointment_date']!,
          timeSlot: appointment['time_slot']!,
          age: appointment['age']!,
          gender: appointment['gender']!,
          email: appointment['email']!,
          number: appointment['mobile']!,
          notes: appointment['comment']!,
          status: appointment['status']!,
          onApprove: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${appointment['name']} approved!')),
            );
          },
          onDecline: (reason) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${appointment['name']} declined: $reason')),
            );
          },
          onJoinCall: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Join call')),
            );
          },
        );
      },
    );
  }
}
