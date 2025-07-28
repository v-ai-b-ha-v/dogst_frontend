import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  const SquareTile({super.key,
  required this.img,
  required this.onTap
  });
  final String img;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15) 
        ),
        child: Image.asset(img,
        height: 40,
        width: 40,),
      ),
    );
  }
}