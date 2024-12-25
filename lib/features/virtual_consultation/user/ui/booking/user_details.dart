import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  final void Function(Map<String, dynamic> data)? onDataChanged;

  const UserDetails({Key? key, this.onDataChanged}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? gender;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void _triggerDataChanged() {
    widget.onDataChanged?.call({
      'fullName': fullNameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'gender': gender,
      'age': ageController.text,
      'comments': commentsController.text,
    });
  }

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
              'Full Name', _buildTextField('Enter Full Name', Icons.person, fullNameController)),
          const SizedBox(height: 10),

          // Email
          _buildLabelAndField(
              'Email', _buildTextField('Enter Email', Icons.email, emailController)),
          const SizedBox(height: 10),

          // Mobile Number
          _buildLabelAndField('Mobile Number',
              _buildTextField('Enter Mobile Number', Icons.phone, mobileController)),
          const SizedBox(height: 10),

          // Age
          _buildLabelAndField('Age',
              _buildTextField('Enter Age', Icons.cake, ageController)),
          const SizedBox(height: 20),

          const Divider(),

          const Text('Additional Information',
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

          const Divider(),

          // Comments TextBox
          _buildLabelAndField(
            'Comments',
            TextField(
              controller: commentsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your comments',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (value) {
                _triggerDataChanged();
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
      ),
      onChanged: (value) {
        _triggerDataChanged();
      },
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    return SizedBox(
      width: 105,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            gender = label;
          });
          _triggerDataChanged();
        },
        icon: Icon(icon),
        label: Text(label),
        style: TextButton.styleFrom(
          backgroundColor: gender == label ? Colors.blue : Colors.white,
          foregroundColor: gender == label ? Colors.white : Colors.black,
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
