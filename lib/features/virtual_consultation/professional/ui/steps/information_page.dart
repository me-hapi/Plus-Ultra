import 'package:flutter/material.dart';

class InformationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const InformationPage({Key? key, required this.onDataChanged}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  String? selectedTitle;
  String? selectedJob;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _triggerDataChanged() {
    widget.onDataChanged({
      'title': selectedTitle,
      'fullName': fullNameController.text,
      'jobTitle': selectedJob,
      'bio': bioController.text,
      'mobile': mobileController.text,
      'email': emailController.text,
    });
  }

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(_triggerDataChanged);
    bioController.addListener(_triggerDataChanged);
    mobileController.addListener(_triggerDataChanged);
    emailController.addListener(_triggerDataChanged);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Dropdown
              Text('Title'),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedTitle,
                items: ['Dr.', 'Mr.', 'Ms.']
                    .map((title) => DropdownMenuItem(
                          value: title,
                          child: Text(title),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTitle = value;
                    _triggerDataChanged();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Full Name
              Text('Full Name'),
              SizedBox(height: 8.0),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your full name',
                ),
              ),
              SizedBox(height: 16.0),

              // Job Title / Specialization Dropdown
              Text('Job Title'),
              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedJob,
                items: [
                  'Psychologist',
                  'Psychiatrist',
                  'Guidance Counselor',
                  'Social Worker'
                ]
                    .map((job) => DropdownMenuItem(
                          value: job,
                          child: Text(job),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedJob = value;
                    _triggerDataChanged();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Bio / Short Description
              Text('Bio'),
              SizedBox(height: 8.0),
              TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write a short description about yourself',
                ),
              ),
              SizedBox(height: 16.0),

              // Contact Information
              Text('Mobile No.'),
              SizedBox(height: 8.0),
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your contact information',
                ),
              ),
              SizedBox(height: 16.0),

              // Email
              Text('Email'),
              SizedBox(height: 8.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email address',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
