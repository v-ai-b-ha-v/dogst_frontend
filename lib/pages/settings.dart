import 'package:dogst_ui/pages/loginpage.dart';
import 'package:dogst_ui/pages/registerpage.dart';
import 'package:dogst_ui/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lucide_icons/lucide_icons.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _resetPassword() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Center(child: Text("Reset Password")),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Get the password reset link."),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email..",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Email field is empty")),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: email,
                          );

                          if (!mounted) return;

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password reset email sent"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;

                          Navigator.of(context).pop(); // Close dialog

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to send reset email"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          241,
                          134,
                          77,
                        ),
                      ),
                      child: Text("Send"),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  void _confirmDelete() {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Center(child: Text("Confirm Delete")),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
              
                    decoration: InputDecoration(
                      labelText: "Email..",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Password..",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String password = passwordController.text.trim();
                        String email = emailController.text.trim();

                        if (password.isEmpty || email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Email or Password fields are empty",
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          final idToken =
                              await user
                                  ?.getIdToken(); 

                          if (idToken != null) {
                            await http.delete(
                              Uri.parse(
                                'https://dogst-backend.onrender.com/api/user/delete',
                              ),
                              headers: {'Authorization': 'Bearer $idToken'},
                            );
                          }

                          await authService.value.deleteAccount(
                            email: email,
                            password: password,
                          );

                          if (!mounted) return;

                          Navigator.of(ctx).pop(); // Close dialog first

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User account deleted")),
                          );
                        } catch (e) {
                          if (!mounted) return;

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Something went wrong")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          246,
                          106,
                          106,
                        ),
                      ),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
     resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
            fontSize: height * 0.035,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 61, 162, 238),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children:[
          
          
            Image.asset('assets/settings_bg.png',
            height: height,
            fit: BoxFit.cover,
            ),
          

           Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
              child: Card(
                elevation: 4,
                color: Color.fromARGB(255, 241, 230, 111),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    LucideIcons.edit,
                    color: const Color.fromARGB(255, 246, 171, 8),
                    size: 28,
                  ),
                  title: Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 89, 80, 3),
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => _resetPassword(),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
              child: Card(
                elevation: 4,
                color: Color(0xFFFFEAEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    LucideIcons.trash,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  title: Text(
                    "Delete Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () => _confirmDelete(),
                ),
              ),
            ),
          ],
        ),]
      ),
    );
  }
}
