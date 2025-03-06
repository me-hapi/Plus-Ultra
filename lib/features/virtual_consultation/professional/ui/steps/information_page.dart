import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';
import 'package:lingap/features/virtual_consultation/professional/logic/information_logic.dart';

class InformationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const InformationPage({Key? key, required this.onDataChanged})
      : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  late InformationLogic _logic;
  String? selectedTitle;
  String? selectedJob;
  bool isOthersSelected = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final List<String> specialtyList = [];
  final List<Map<String, TextEditingController>> _controllersList = [
    {
      'institution': TextEditingController(),
      'date': TextEditingController(),
      'experience': TextEditingController(),
    }
  ];

  void _triggerDataChanged() {
    widget.onDataChanged({
      'profile': _logic.frontImage,
      'title': selectedTitle,
      'fullName': fullNameController.text,
      'jobTitle': selectedJob,
      'bio': bioController.text,
      'mobile': mobileController.text,
      'email': emailController.text,
      'specialty': specialtyList,
      'experience': _controllersList
    });
  }

  final Map<String, String> categories = {
    "Addiction": "assets/consultation/addiction.png",
    "Anxiety": "assets/consultation/anxiety.png",
    "Children": "assets/consultation/children.png",
    "Depression": "assets/consultation/depression.png",
    "Food": "assets/consultation/food.png",
    "Grief": "assets/consultation/grief.png",
    "LGBTQ": "assets/consultation/lgbtq.png",
    "Psychosis": "assets/consultation/psychosis.png",
    "Sleep": "assets/consultation/sleep.png",
    "Relationship": "assets/consultation/relationship.png",
    "Others": "assets/consultation/schedule.png"
  };

  void _addNewFields() {
    setState(() {
      _controllersList.add({
        'institution': TextEditingController(),
        'date': TextEditingController(),
        'experience': TextEditingController(),
      });
    });

    _triggerDataChanged();
  }

  @override
  void initState() {
    super.initState();
    _logic = InformationLogic(onDataChanged: (data) {
      setState(() {});
      widget.onDataChanged(data);
    });

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

  Widget _buildImageContainer(File? imageFile) {
    return GestureDetector(
      onTap: () async {
        await _logic.pickImage(context);
      },
      child: Container(
        width: 200,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: mindfulBrown['Brown80']!, width: 2),
          color: Colors.white,
        ),
        child: imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Text(
                  'Upload Profile',
                  style:
                      TextStyle(fontSize: 16, color: mindfulBrown['Brown80']),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _buildImageContainer(_logic.frontImage),
              ),
              // Title Dropdown
              Text(
                'Title',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
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
                  prefixIcon: Icon(Icons.person), // Add a prefix icon
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No visible border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: serenityGreen['Green50']!, // Focus border color
                      width: 2.0, // Focus border width
                    ),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Padding
                ),
              ),

              SizedBox(height: 16.0),

              // Full Name
              Text(
                'Full Name',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person), // Add a prefix icon
                  hintText: 'Enter your full name', // Placeholder text
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide(
                      color: serenityGreen[
                          'Green50']!, // Green border when focused
                      width: 2.0, // Width of the border
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Adjust padding for better appearance
                ),
              ),

              SizedBox(height: 16.0),

              // Job Title / Specialization Dropdown
              Text(
                'Job Title',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
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
                  prefixIcon: Icon(Icons.person), // Add a prefix icon
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No visible border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: serenityGreen['Green50']!, // Focus border color
                      width: 2.0, // Focus border width
                    ),
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Padding
                ),
              ),
              SizedBox(height: 16.0),

              // Bio / Short Description
              Text(
                'Bio',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write a short description about yourself',
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide(
                      color: serenityGreen[
                          'Green50']!, // Green border when focused
                      width: 2.0, // Width of the border
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Adjust padding for better appearance
                ),
              ),
              SizedBox(height: 16.0),

              // Contact Information
              Text(
                'Mobile No.',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  hintText: 'Enter your contact information',
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide(
                      color: serenityGreen[
                          'Green50']!, // Green border when focused
                      width: 2.0, // Width of the border
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Adjust padding for better appearance
                ),
              ),
              SizedBox(height: 16.0),

              // Email
              Text(
                'Email',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  fillColor: Colors.white, // Background fill color
                  filled: true, // Enable the fill color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // No default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide(
                      color: serenityGreen[
                          'Green50']!, // Green border when focused
                      width: 2.0, // Width of the border
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ), // Adjust padding for better appearance
                ),
              ),

              SizedBox(
                height: 32,
              ),
              Text(
                'Specializations',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: categories.entries.map((entry) {
                  final String category = entry.key;
                  final String imagePath = entry.value;

                  final bool isSelected = specialtyList.contains(category);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (category == 'Others') {
                          // Toggle the selection for Others.
                          isOthersSelected = !isOthersSelected;
                          if (!isOthersSelected) {
                            // If unselected, clear the text field and remove any custom entry.
                            specialtyList.removeWhere(
                                (element) => element == otherController.text);
                            otherController.clear();
                          }
                        } else {
                          // For other categories, simply toggle their presence in the list.
                          if (isSelected) {
                            specialtyList.remove(category);
                          } else {
                            specialtyList.add(category);
                          }
                        }
                        _triggerDataChanged();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? serenityGreen['Green50']
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            imagePath,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(width: 8),
                          Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              
              if (isOthersSelected)
              SizedBox(height: 10,),
              if (isOthersSelected)
                TextFormField(
                  controller: otherController,
                  onChanged: (value) {
                    setState(() {
                      // Remove any previous custom "Others" entry.
                      specialtyList.removeWhere(
                          (element) => element == value || element == 'Others');
                      // If the field is not empty, add the current value.
                      if (value.isNotEmpty) {
                        specialtyList.add(value);
                      }
                      _triggerDataChanged();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Image.asset('assets/consultation/schedule.png', width: 20, height: 20,),
                    hintText: 'Enter your specialization',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: serenityGreen['Green50']!,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                ),

              SizedBox(
                height: 32,
              ),
              Text(
                'Experience & Education',
                style: TextStyle(
                    color: mindfulBrown['Brown80'],
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  for (var i = 0; i < _controllersList.length; i++)
                    Column(
                      children: [
                        TextFormField(
                          controller: _controllersList[i]['institution'],
                          decoration: InputDecoration(
                            hintText: 'Institution',
                            fillColor: Colors.white, // Background fill color
                            filled: true, // Enable the fill color
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide.none, // No default border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide(
                                color: serenityGreen[
                                    'Green50']!, // Green border when focused
                                width: 2.0, // Width of the border
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ), // Adjust padding for better appearance
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _controllersList[i]['date'],
                          decoration: InputDecoration(
                            hintText: 'Date',
                            fillColor: Colors.white, // Background fill color
                            filled: true, // Enable the fill color
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide.none, // No default border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide(
                                color: serenityGreen[
                                    'Green50']!, // Green border when focused
                                width: 2.0, // Width of the border
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ), // Adjust padding for better appearance
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _controllersList[i]['experience'],
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Experience',
                            fillColor: Colors.white, // Background fill color
                            filled: true, // Enable the fill color
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide.none, // No default border
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Rounded corners
                              borderSide: BorderSide(
                                color: serenityGreen[
                                    'Green50']!, // Green border when focused
                                width: 2.0, // Width of the border
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ), // Adjust padding for better appearance
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: mindfulBrown['Brown30'],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: mindfulBrown['Brown30'],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: mindfulBrown['Brown30'],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  SizedBox(
                      height: 50,
                      width: 120,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton(
                          onPressed: _addNewFields,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: serenityGreen['Green50'],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )),
                  SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
