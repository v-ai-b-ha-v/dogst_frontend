import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  void _launchURL(BuildContext context,String Url) async {

    final Uri url = Uri.parse(Url);

    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch link')),
    );
    }

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("About Me"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Stack(
        children: [

          Positioned.fill(
            
            child: Lottie.asset('assets/aboutme.json', fit: BoxFit.fill,),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              const SizedBox(height: 16),
          
              // Name
              Text(
                "Vaibhav Rawat",
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
          
              // Title
              Text(
                "Flutter Developer | Fullstack Explorer",
                style: TextStyle(fontSize: 18,
                fontStyle: FontStyle.italic,
                 color: Colors.grey.shade900),
              ),
          
              const SizedBox(height: 24),
          
              // Bio
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "I'm a passionate mobile developer focused on building clean and delightful user experiences. I love building apps that solve real problems and enjoy backend work too.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
          
              const SizedBox(height: 30),
          
              // Skills
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Skills",
                  style: GoogleFonts.fredoka(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                alignment : WrapAlignment.center,
                runSpacing: 10,
                children: [
                  Chip(label: Text("Flutter")),
                  Chip(label: Text("Firebase")),
                  Chip(label: Text("Node.js")),
                  Chip(label: Text("MongoDB")),
                  Chip(label: Text("Express.js")),

                  
                ],
              ),
          
              const SizedBox(height: 30),
          
              // Contact
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Contact",
                  style: GoogleFonts.fredoka(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
          
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mail Icon
              IconButton(
                icon: const Icon(LucideIcons.mailCheck),
                color: Colors.black,
                iconSize: 38,
               
                onPressed: () {
                  _launchURL(context,'mailto:vaibhavrawat2004@gmail.com');
                },
              ),
          
           
          
              // GitHub Icon
              IconButton(
                icon: const Icon(LucideIcons.github),
                iconSize: 38,
               
                color: Colors.black,
                onPressed: () {
                  _launchURL(context,'https://github.com/v-ai-b-ha-v');
                },
              ),

               // Linkedin Icon
              IconButton(
                icon: const Icon(LucideIcons.linkedin),
                color: Colors.black,
                iconSize: 38,
               
                onPressed: () {
                  _launchURL(context,'https://www.linkedin.com/in/-vaibhav-rawat/');
                },
              ),
          
        
              
            ],
          ),
              
          
            ],
          ),
        ],
      ),
    );
  }
}
