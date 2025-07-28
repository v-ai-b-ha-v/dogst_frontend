import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.white,
            
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget ruleItem(String description) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          textAlign: TextAlign.start,
          "• $description",
          style: GoogleFonts.poppins(fontSize: 19,
          color: Colors.white
          ),
          
        ),
      );

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "XP Rules & Levels",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          
        ),
        backgroundColor: Colors.grey.shade600,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          
          Image.asset('assets/blackboard.png',
          height: double.infinity,
          fit: BoxFit.cover,
          
          )
          ,Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
            children: [
                  
              sectionTitle("🎯 Daily XP"),
              ruleItem("Stay under your daily target to earn +25 XP."),
              ruleItem("Exceeding target gives 0 XP."),

              SizedBox(height: 25,),
                    
              sectionTitle("⚡ Bonus XP (based on screen time)"),
              ruleItem("0–30 min → +150 XP"),
              ruleItem("31–60 min → +100 XP"),
              ruleItem("61–120 min → +70 XP"),
              ruleItem("121–180 min → +40 XP"),
              ruleItem("181–240 min → +20 XP"),
              ruleItem("241–300 min → +10 XP"),
              ruleItem("> 300 min → 0 XP"),

              SizedBox(height: 25,),
                    
              sectionTitle("🔥 Streak XP"),
              ruleItem("You get +3 XP per streak day."),
              ruleItem("Max streak XP per day: 100 XP."),

              SizedBox(height: 25,),
                    
              sectionTitle("⏰ XP Update Timing"),
              ruleItem("Your XP is calculated and updated only once every day at midnight."),
              ruleItem("Bonus, streak, and target XP are all evaluated then."),

              SizedBox(height: 25,),
                    
              sectionTitle("🏆 Levels"),
              ruleItem("Level 2 → 166 XP"),
              ruleItem("Level 3 → 400 XP"),
              ruleItem("Level 4 → 666 XP"),
              ruleItem("... up to Level 20 → 14000 XP"),

              SizedBox(height: 25,),
                    
              sectionTitle("🐶 Pet Evolution by Level"),
              ruleItem("1–3 → Chihuahua"),
              ruleItem("4–6 → Pomeranian"),
              ruleItem("7–9 → Pug"),
              ruleItem("10–12 → Beagle"),
              ruleItem("13–15 → Cocker Spaniel"),
              ruleItem("16–18 → Golden Retriever"),
              ruleItem("19–20 → Great Dane"),
            ],
                    ),
          ),]
      ),
    );
  }
}
