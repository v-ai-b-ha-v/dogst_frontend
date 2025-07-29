import 'dart:convert';
import 'dart:math';
import 'package:dogst_ui/components/drawerdash.dart';
import 'package:dogst_ui/components/petcard.dart';
import 'package:dogst_ui/usage/packageToApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic>? userData;

  int _screenTimeToday = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> onSync() async {
    try {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wait for 10-15 seconds"),
        duration: Duration(milliseconds: 800),
        )
      );

      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      final urlGet = Uri.parse('https://dogst-backend.onrender.com/api/user/lastUpdated');

      final response = await http.get(
        urlGet,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        DateTime currentDate = DateTime.now();
        final json = jsonDecode(response.body);

        final lastUpdatedString = json['lastUpdated'];

        final lastUpdated = DateTime.parse(lastUpdatedString).toLocal();


        final now = DateTime.now();

        

        print(now);
        print(lastUpdated);

        // Check if same day:
        bool isSameDay =
            lastUpdated.year == now.year &&
            lastUpdated.month == now.month &&
            lastUpdated.day == now.day;

        print(isSameDay);

        final obj = PackagetoAppName();
        await obj.init();

        final urlPost = Uri.parse("https://dogst-backend.onrender.com/api/user/updateStats");

        if (isSameDay) {

          print('it is same day');
          int screenTimeToday = await obj.getTodayScreenTime();

          setState(() {
            _screenTimeToday = screenTimeToday;
          });

          print("SCREEN TIME TODAY IS ONLY : ${screenTimeToday}");

          final response = await http.post(
            urlPost,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'screenTimeToday': screenTimeToday}),
          );

          print('response is : ${response.body}');
          print('Response receieved ${response.statusCode}');

          if (response.statusCode == 200) {
            final result = jsonDecode(response.body);

            await fetchUserData();

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully synced data"),
                duration: Duration(milliseconds: 700),
              ),
            );
          } else {
            print("Failed to update stats. Status: ${response.body}");
          }
        } else {
          List<int> list = await obj.getPrevAndCurrentDayUsage();

          int prevDayScreenTime = list[0];
          int currentScreenTime = list[1];

          setState(() {
            _screenTimeToday = currentScreenTime;
          });

          final response = await http.post(
            urlPost,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'prevDayScreenTime': prevDayScreenTime,
              'currentScreenTime': currentScreenTime,
            }),
          );

          if (response.statusCode == 200) {
            final result = jsonDecode(response.body);

            await fetchUserData();

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully synced data"),
                duration: Duration(milliseconds: 700),
              ),
            );
          } else {
            print("Failed to update stats. Status: ${response.statusCode}");
          }
        }

        print("User Data: $json");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not sync data"),
          duration: Duration(milliseconds: 1500),
        ),
      );
      print("Fetch error: $e");
    }
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      final url = Uri.parse('https://dogst-backend.onrender.com/api/user/me');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          userData = json;
        });
        print("User Data: $json");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),

      drawer: DashboardDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Lottie.asset(
            'assets/dashboard_background.json',
            fit: BoxFit.cover,
            height: height,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.07),
                  child: Text(
                    "Welcome",
                    style: GoogleFonts.bangers(
                      fontSize: height * 0.025,

                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: width * 0.07),
                  child: Text(
                    userData != null
                        ? userData!['name'] ?? "N/A"
                        : "Loading...",
                    style: GoogleFonts.merriweather(
                      fontSize: height * 0.04,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.02),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 80, 47, 158),
                                  Color.fromARGB(255, 123, 48, 172),
                                ],
                              ),
                            ),
                            height: height * 0.2,
                            width: width * 0.45,
                            child: CircularPercentIndicator(
                              radius: width * 0.2,
                              lineWidth: width * 0.02,
                              animation: true,
                              animationDuration: 2500,
                              percent:
                                  (userData != null &&
                                          userData!['screenTimeToday'] !=
                                              null &&
                                          userData!['userTargetScreenTime'] !=
                                              null &&
                                          userData!['userTargetScreenTime'] !=
                                              0)
                                      ? min(
                                        1,
                                        userData!['screenTimeToday'] /
                                            userData!['userTargetScreenTime'],
                                      )
                                      : 0.0,

                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.red.shade600,
                              backgroundColor: Colors.green,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Daily Minutes",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    userData != null
                                        ? "${_screenTimeToday} / ${userData!['userTargetScreenTime']}"
                                        : "Loading...",
                                    style: GoogleFonts.akatab(
                                      fontSize: width * 0.06,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.03),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: Colors.purple,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 80, 47, 158),
                                  Color.fromARGB(255, 123, 48, 172),
                                ],
                              ),
                            ),
                            height: height * 0.2,
                            width: width * 0.45,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: width * 0.15,
                                  child: SizedBox(
                                    height: height * 0.20,
                                    width: width * 0.43,
                                    child: Transform.rotate(
                                      angle: -90 * 3.1416 / 180,
                                      child: LinearPercentIndicator(
                                        progressBorderColor: Colors.blue,
                                        progressColor: Colors.blue,
                                        backgroundColor: Colors.blue.shade100,
                                        percent:
                                            (userData != null &&
                                                    userData!['xp'] != null &&
                                                    userData!['reqXP'] !=
                                                        null &&
                                                    (userData!['xp'] +
                                                            userData!['reqXP']) !=
                                                        0)
                                                ? min(
                                                  1,
                                                  userData!['xp'] /
                                                      (userData!['xp'] +
                                                          userData!['reqXP']),
                                                )
                                                : 0.5,
                                        animation: true,
                                        animationDuration: 1500,
                                        barRadius: Radius.circular(width * 0.5),
                                        lineHeight: height * 0.02,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: width * 0.15,
                                  top: height * 0.08,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "XP Progress",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: height * 0.018,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        (userData != null &&
                                                userData!['xp'] != null &&
                                                userData!['reqXP'] != null)
                                            ? "${userData!['xp']} / ${userData!['xp'] + userData!['reqXP']}"
                                            : "Loading...",
                                        style: GoogleFonts.poppins(
                                          fontSize: height * 0.015,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                PetCard(
                  level: userData != null ? userData!['level'] : -1,
                  petName: userData != null ? userData!['petType'] : "Unnamed",
                  streak: userData != null ? userData!['streak'] : -1,
                ),
                SizedBox(height: height * 0.03),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSync();
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
                        horizontal: width * 0.30,
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
          ),
        ],
      ),
    );
  }
}
