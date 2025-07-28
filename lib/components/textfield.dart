import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hide,
    required this.hintText,
  });

  final String hintText;
  final TextEditingController controller;
  final bool hide;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: _isFocused ? width * 0.96 : width * 0.88,

        child: TextField(
          controller: widget.controller,
          obscureText: widget.hide,
          keyboardType: TextInputType.emailAddress,
          
          focusNode: _focusNode,
          decoration: InputDecoration(
            
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              
              borderSide: const BorderSide(color: Colors.orange),
            ),
            fillColor: !_isFocused ?Colors.white.withValues(alpha: 0.7):Colors.white.withValues(alpha: 0.85),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.green.shade400),
            ),
          ),
        ),
      ),
    );
  }
}
