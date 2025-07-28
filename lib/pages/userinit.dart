import 'dart:convert';

import 'package:dogst_ui/pages/FormPages/init_name_card.dart';
import 'package:dogst_ui/pages/FormPages/init_slider_card.dart';
import 'package:dogst_ui/pages/FormPages/init_submit_card.dart';
import 'package:dogst_ui/pages/loginpage.dart';
import 'package:dogst_ui/pages/userinitialroute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class InitFormPage extends StatefulWidget {
  @override
  _InitFormPageState createState() => _InitFormPageState();
}

class _InitFormPageState extends State<InitFormPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  double _screenTime = 60;
  double cardWidth = 300;
  double spacing = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _scrollNext() {
    final double scrollAmount = cardWidth + spacing;
    final currentOffset = _scrollController.offset;
    final targetOffset = currentOffset + scrollAmount;
    final maxExtent = _scrollController.position.maxScrollExtent;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, maxExtent),
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length < 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Name")));
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Not logged in")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return;
      }

      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse('https://dogst-backend.onrender.com/api/user/init'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'name': name,
          'userTargetScreenTime': _screenTime.round(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("User Registered ✅")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserInitRouterPage()));
      } else {
        print(response.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Init failed ❌")));
      }
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    cardWidth = width * 0.75;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/onboard_animation.json',
            fit: BoxFit.cover,
            height: height,
            width: width,
            alignment: Alignment.center, // fills the screen without distortion
          ),

          Positioned(
            top: height * 0.8,
            left: width * 0.4,
            child: Lottie.asset(
              'assets/dogsloop.json',
              height: 100,
              width: 150,
              alignment:
                  Alignment.center, // fills the screen without distortion
            ),
          ),

          Column(
            children: [
              SizedBox(height: height * 0.15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Just a few moments !!",
                  style: TextStyle(
                    fontSize: height * 0.02,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: height * 0.35,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: SingleChildScrollView(
                    
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InitNameCard(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          onNext: _scrollNext,
                          cardWidth: cardWidth,
                          spacing: spacing,
                        ),
                        InitSliderCard(
                          screenTime: _screenTime,
                          onChanged: (val) => setState(() => _screenTime = val),
                          onNext: _scrollNext,
                          cardWidth: cardWidth,
                          spacing: spacing,
                        ),
                        InitSubmitCard(
                          onSubmit: _submit,
                          cardWidth: cardWidth,
                          spacing: spacing,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
