import 'package:dogst_ui/pages/homepage.dart';
import 'package:dogst_ui/pages/loginpage.dart';
import 'package:dogst_ui/pages/userinit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInitRouterPage extends StatefulWidget {
  @override
  _UserInitRouterPageState createState() => _UserInitRouterPageState();
}

class _UserInitRouterPageState extends State<UserInitRouterPage> {
  @override
  void initState() {
    super.initState();
    _checkUserInitialized();
  }

  Future<void> _checkUserInitialized() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()) );
      return;
    }

    final idToken = await user.getIdToken();

    try {

      print("okay to mai yaha se start kar rha hu");

      final response = await http.get(
        Uri.parse('https://dogst-backend.onrender.com/api/user/me'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      print("yeh rha response ${response}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        final target = data['userTargetScreenTime'];

        if(!mounted) return;

        if (target != null && target > 0) {
            print("✅ User is initialized with target: $target");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          print("target time galat hai ${target}");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InitFormPage()));
        }
      } else {
        print("yeh rha response ${response}");
         print('❌ Non-200 response: ${response.statusCode} -> ${response.body}');
        if(!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InitFormPage()));
        print('Error fetching user: ${response.body}');
      }
    } catch (e) {
      if(!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InitFormPage()));
      print('Exception in /me call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
