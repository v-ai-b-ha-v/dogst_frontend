import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InitNameCard extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onNext;
  final double cardWidth;
  final double spacing;

  const InitNameCard({
    required this.controller,
    required this.focusNode,
    required this.onNext,
    required this.cardWidth,
    required this.spacing,
  });

  @override
  State<InitNameCard> createState() => _InitNameCardState();
}

class _InitNameCardState extends State<InitNameCard> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _buildCard(
      widget.spacing,
      widget.cardWidth,
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset('assets/walkingdog1.json', height: height * 0.15),
        
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width:
                    _isFocused ? widget.cardWidth * 0.9 : widget.cardWidth * 0.7,
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: " Name....",
        
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
        
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
        
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
        
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onNext,
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
      ),
    );
  }

  Widget _buildCard(double spacing, double width, Widget child) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: Card(
        shadowColor: const Color.fromARGB(255, 205, 69, 229),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
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
          padding: EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
