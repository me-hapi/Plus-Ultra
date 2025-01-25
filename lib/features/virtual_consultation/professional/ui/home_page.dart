import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
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
  String selectedButton = "Pending";

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
      backgroundColor: mindfulBrown['Brown10'],
      appBar: AppBar(
        backgroundColor: mindfulBrown['Brown10'],
        title: Text(
          'Appointments',
          style: TextStyle(color: mindfulBrown['Brown80'], fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildToggleButton("Pending", empathyOrange['Orange40']!),
                  _buildToggleButton("Approved", reflectiveBlue['Blue50']!),
                  _buildToggleButton("Completed", serenityGreen['Green50']!),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
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
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, Color activeColor) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedButton = label;
          });
        },
        child: SizedBox(
          width: 100,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              color: selectedButton == label ? activeColor : Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              textAlign: TextAlign.center,
              label,
              style: TextStyle(
                color: selectedButton == label ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
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
