import 'package:flutter/material.dart';

class InitSliderCard extends StatelessWidget {
  final double screenTime;
  final ValueChanged<double> onChanged;
  final VoidCallback onNext;
  final double cardWidth;
  final double spacing;

  const InitSliderCard({
    required this.screenTime,
    required this.onChanged,
    required this.onNext,
    required this.cardWidth,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _buildCard(
      spacing,
      cardWidth,
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height*0.04,
          ),
          Text("Target Screen Time",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: height*0.018
            ),),
          Text("${screenTime.round()} min", style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: height*0.04)),
          Slider(
            min: 15,
            max: 300,
            divisions: 19,
            label: screenTime.round().toString(),
            value: screenTime,
            onChanged: onChanged,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 192, 150, 232), // soft lavender
              foregroundColor: Colors.white, // text/icon color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Next",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
          ),
          ],
      ),
    );
  }

  Widget _buildCard(double spacing, double width, Widget child) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: Card(
        shadowColor: const Color.fromARGB(255, 205, 69, 229),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Color(0xFFBFA2DB), // Soft lavender
                Color.fromARGB(255, 203, 174, 234), // Light lilac
                Color.fromARGB(255, 208, 179, 239), // Almost pastel purple
                Color(0xFFBFA2DB),
              ],
            ),
          ),
          width: width,
          padding: EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
