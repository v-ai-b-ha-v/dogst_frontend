import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<dynamic>? leaderboard;

  Future<void> fetchLeaderboard() async {
    try {

      setState(() {
        leaderboard = [];
      });


      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      final urlGet = Uri.parse(
        'https://dogst-backend.onrender.com/api/user/leaderboard',
      );

      final response = await http.get(
        urlGet,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("--------hello-----------");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        setState(() {
          leaderboard = json;
        });
        print(leaderboard);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not get leaderboard"),
          duration: Duration(milliseconds: 1500),
        ),
      );
      print("Fetch error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/leaderboard_bg.png',
            height: height,
            width: width,
            fit: BoxFit.fill,
          ),

          Positioned(
            top: height * 0.03,
            height: height * 0.15,
            right: 0,
            child: Lottie.asset('assets/podium.json'),
          ),

          Positioned(
            top: height * 0.1,
            height: height * 0.15,
            left: width * 0.1,
            child: Text(
              'Leaderboard',
              style: GoogleFonts.electrolize(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: height * 0.04,
              ),
            ),
          ),
          
          if (leaderboard == null || leaderboard!.isEmpty)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/loading.json',
                  height: height*0.05,
                  
                  ),
                  GestureDetector(
                    onTap: () => fetchLeaderboard(),
                    child: Text(
                    "Refreshing !!",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                                    ),
                  ),
                ]
              ),
            )
          else
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.2),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: height * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(52),
                    child: ListView.builder(
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),

                      itemCount: leaderboard == null ? 0 : leaderboard!.length,
                      itemBuilder: (context, index) {
                        final user = leaderboard![index];
                        final name = user['name'] ?? "Unknown";
                        final xp = user['xp'] ?? 0;

                        // 🏆 Medal emojis for top 3
                        String? medal;
                        if (index == 0)
                          medal = "🥇";
                        else if (index == 1)
                          medal = "🥈";
                        else if (index == 2)
                          medal = "🥉";

                        return Card(
                          color:
                              index == 0
                                  ? const Color(0xFFFFD700) // Gold
                                  : index == 1
                                  ? const Color.fromARGB(
                                    255,
                                    171,
                                    169,
                                    169,
                                  ) // Silver
                                  : index == 2
                                  ? const Color(0xFFCD7F32) // Bronze
                                  : const Color(0xFFF5F5F5), // Normal,
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
                              "$xp XP",
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

                SizedBox(height: height * 0.02),

                Center(
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

                      fetchLeaderboard();
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
                      "Refresh",
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
