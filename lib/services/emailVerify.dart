import 'package:dogst_ui/pages/registerpage.dart';
import 'package:dogst_ui/services/auth_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isVerified = false;
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    setState(() => isChecking = true);

    await FirebaseAuth.instance.currentUser?.reload(); // Refresh user data
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      isVerified = user?.emailVerified ?? false;
      isChecking = false;
    });

    if (isVerified) {
      // Navigate to home or next screen
      if(mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthLayout(pageIsNotConnected: RegisterPage()))); // or use MaterialPageRoute
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        centerTitle: true,
      ),
      body: Center(
        child: isChecking
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email_outlined, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    "A verification email has been sent to your inbox.\nPlease verify to continue.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: checkEmailVerified,
                    child: const Text("I have verified"),
                  ),
                ],
              ),
      ),
    );
  }
}
