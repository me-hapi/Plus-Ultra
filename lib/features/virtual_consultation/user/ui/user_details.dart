import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  double weight = 60.0;
  double height = 170.0;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Full Name
          _buildLabelAndField(
              'Full Name', _buildTextField('Enter Full Name', Icons.person)),
          const SizedBox(height: 10),

          // Email
          _buildLabelAndField(
              'Email', _buildTextField('Enter Email', Icons.email)),
          const SizedBox(height: 10),

          // Mobile Number
          _buildLabelAndField('Mobile Number',
              _buildTextField('Enter Mobile Number', Icons.phone)),
          const SizedBox(height: 20),

          const Divider(),

          const Text('Medical Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Gender Selection
          const Text('Gender', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGenderButton('Male', Icons.male),
              _buildGenderButton('Female', Icons.female),
              _buildGenderButton('Others', Icons.transgender),
            ],
          ),
          const SizedBox(height: 20),

          // Weight Slider
          _buildLabelAndField(
            'Weight (kg)',
            Slider(
              value: weight,
              min: 30,
              max: 200,
              divisions: 170,
              label: '${weight.toStringAsFixed(1)} kg',
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
          ),

          // Height Slider
          _buildLabelAndField(
            'Height (cm)',
            Slider(
              value: height,
              min: 100,
              max: 250,
              divisions: 150,
              label: '${height.toStringAsFixed(1)} cm',
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
            ),
          ),

          // Birth Date Picker
          _buildLabelAndField(
            'Birth Date',
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  selectedDate == null
                      ? 'Select Birth Date'
                      : '${selectedDate!.toLocal()}'.split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Divider(),

          // Comments TextBox
          _buildLabelAndField(
            'Comments',
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your comments',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true, // Enable the filled background
        fillColor: Colors.white, // Set the background color to white
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    return SizedBox(
      width: 105,
      child: TextButton.icon(
        onPressed: () {
          // Add gender selection logic here
        },
        icon: Icon(icon),
        label: Text(label),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelAndField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        field,
      ],
    );
  }
}
