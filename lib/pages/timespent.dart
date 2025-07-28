import 'dart:convert';
import 'package:dogst_ui/usage/model/appusage.dart';
import 'package:dogst_ui/usage/packageToApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class TimeSpentPage extends StatefulWidget {
  const TimeSpentPage({super.key});

  @override
  State<TimeSpentPage> createState() => _TimeSpentPageState();
}

class _TimeSpentPageState extends State<TimeSpentPage> {
  List<AppUsage>? list = [];

  Future<void> getTimeList() async {

    setState(() {
    list = []; 
  });

    final obj = PackagetoAppName();
    await obj.init();
    DateTime now = DateTime.now();
    await obj.fetchAndProcessUsage(DateTime(now.year, now.month, now.day), now);
    setState(() {
      list = obj.getSortedByUsage();
    });

    print(list);
  }

  @override
  void initState() {
    super.initState();
    getTimeList();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Lottie.asset(
            'assets/applist_bg.json',
            fit: BoxFit.cover,
            height: height,
          ),

          Positioned(
            top: height * 0.08,
            right: width * 0.1,
            child: Lottie.asset('assets/clock.json', height: height * 0.15),
          ),

          Positioned(
            top: height * 0.125,
            left: width * 0.1,
            child: Text(
              "Most Used",
              style: GoogleFonts.fredoka(
                fontSize: height * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (list == null || list!.isEmpty)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/syncing.json',
                  height: height*0.05
                  ),
                  Text(
                  "Syncing !!",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ]
              ),
            )
          else
            Positioned(
              top: height * 0.25,
              left: width * 0.01,
              right: width * 0.01,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: height * 0.5,
                  width: width,
                  child: ListView.builder(
                    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: list == null ? 0 : list!.length,
                    itemBuilder: (context, index) {
                      final user = list![index];
                      final name = user.appName;
                      final time = (user.usageMillis / 60000).round();

                      String? medal;
                      if (index == 0)
                        medal = "☠️";
                      else if (index == 1)
                        medal = "💀";
                      else if (index == 2)
                        medal = "⚠️";

                      return Card(
                        color:
                            index == 0
                                ? const Color.fromARGB(
                                  255,
                                  247,
                                  21,
                                  62,
                                ) // Deep Red – Highly dangerous or toxic
                                : index == 1
                                ? const Color(
                                  0xFFFF6F00,
                                ) // Vivid Orange – Harmful or disruptive
                                : index == 2
                                ? const Color(
                                  0xFFFFC107,
                                ) // Amber/Yellow – Caution, mild concern
                                : const Color(
                                  0xFFE0F7FA,
                                ), // Soft Teal – Neutral or low impact
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              medal ?? "#${index + 1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: medal != null ? 22 : 16,
                              ),
                            ),
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(
                            "$time min",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: height * 0.08,
            left: width * 0.32,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please wait 10–15 seconds for data to refresh...",
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
                getTimeList();
              },
              style: ElevatedButton.styleFrom(
                enableFeedback: true,
                backgroundColor: Color.fromARGB(
                  255,
                  192,
                  150,
                  232,
                ), // soft lavender
                foregroundColor: Colors.white, // text/icon color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1,
                  vertical: height * 0.015,
                ),
              ),
              child: Text(
                "Sync",
                style: GoogleFonts.poppins(
                  fontSize: height * 0.023,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
