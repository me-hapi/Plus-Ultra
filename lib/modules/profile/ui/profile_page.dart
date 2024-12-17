import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingap/features/virtual_consultation/professional/ui/application_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSigningOut = false;

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
      // Show error message if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _applyToBecomeProfessional() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isSigningOut
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Sign Out'),
                  ),
            const SizedBox(height: 40),
            const Text(
              'Want to become a mental health professional?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApplicationPage()));
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
