import 'package:flutter/material.dart';
import 'package:lingap/core/const/colors.dart';

class InformationPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;

  const InformationPage({Key? key, required this.onDataChanged})
      : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                'Specialty',
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
                        if (isSelected) {
                          specialtyList.remove(category);
                        } else {
                          specialtyList.add(category);
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
