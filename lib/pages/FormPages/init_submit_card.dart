import 'package:flutter/material.dart';

class InitSubmitCard extends StatelessWidget {
  final VoidCallback onSubmit;
  final double cardWidth;
  final double spacing;

  const InitSubmitCard({
    required this.onSubmit,
    required this.cardWidth,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      spacing,
      cardWidth,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You're all set!", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 192, 150, 232), // soft lavender
              foregroundColor: Colors.white, // text/icon color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Submit", style: TextStyle(
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
