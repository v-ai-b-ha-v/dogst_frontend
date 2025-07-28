import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key,
  required this.text,
  required this.onTap,
  required this.icon});
  final Function()? onTap;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.blueAccent,
          child: InkWell(
            
            borderRadius: BorderRadius.circular(16),
            
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}