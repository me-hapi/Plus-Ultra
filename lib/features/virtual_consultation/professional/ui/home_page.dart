import 'package:flutter/material.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/appointment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for appointments
  final List<Map<String, String>> pendingAppointments = [
    {
      'name': 'John Doe',
      'notes': 'Feeling stressed',
      'date': 'Dec 10, 2024',
      'timeSlot': '10:00 AM - 11:00 AM',
      'status': 'pending'
    },
    {
      'name': 'Jane Smith',
      'notes': 'Anxiety issues',
      'date': 'Dec 12, 2024',
      'timeSlot': '2:00 PM - 3:00 PM',
      'status': 'pending'
    },
  ];

  final List<Map<String, String>> approvedAppointments = [
    {
      'name': 'Alice Taylor',
      'notes': 'General consultation',
      'date': 'Dec 15, 2024',
      'timeSlot': '9:00 AM - 10:00 AM',
      'status': 'approved'
    },
  ];

  final List<Map<String, String>> completedAppointments = [
    {
      'name': 'Michael Brown',
      'notes': 'Follow-up session',
      'date': 'Dec 8, 2024',
      'timeSlot': '3:00 PM - 4:00 PM',
      'status': 'completed'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          buildAppointmentList(pendingAppointments),
          buildAppointmentList(approvedAppointments),
          buildAppointmentList(completedAppointments),
        ],
      ),
    );
  }

  Widget buildAppointmentList(List<Map<String, String>> appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(
          name: appointment['name']!,
          notes: appointment['notes']!,
          date: appointment['date']!,
          timeSlot: appointment['timeSlot']!,
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
              SnackBar(content: Text('Join call')),
            );
          },
        );
      },
    );
  }
}
