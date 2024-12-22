import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/core/const/const.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/application_page.dart';
import 'package:lingap/modules/home/bottom_nav.dart';
import 'package:lingap/services/database/global_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;
  String accountType = "Patient";
  GlobalSupabase supabase = GlobalSupabase(client);
  bool isProfessional = false;

  @override
  void initState() {
    super.initState();
    _checkProfessionalStatus();
  }

  void _checkProfessionalStatus() async {
    bool result = await supabase.isProfessional(uid);
    setState(() {
      isProfessional = result;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        context.go('/intro');
      }
    } catch (e) {
      setState(() {
        _isSigningOut = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hides the default back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav()));
            context.go('/bottom-nav');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular image
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/profile_placeholder.png'), // Placeholder image
              ),
              const SizedBox(height: 20),

              // Full Name
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Full Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: 'John Doe', // Example placeholder
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),

              // Email
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: 'johndoe@example.com', // Example placeholder
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),

              // Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: '********',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Account Type Toggle Button
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              accountType = "Patient";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isProfessional
                                  ? (accountType == "Patient"
                                      ? Colors.blue
                                      : Colors.transparent)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Patient",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isProfessional
                                    ? (accountType == "Patient"
                                        ? Colors.white
                                        : Colors.black)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: isProfessional
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    accountType = "Professional";
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: accountType == "Professional"
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "Professional",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: accountType == "Professional"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ApplicationPage()));

                                      context.push('/application_page');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Apply",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  )),
              const SizedBox(height: 40),

              // Sign Out Button
              _isSigningOut
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        context.push('/application_page');
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Sign Out'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
