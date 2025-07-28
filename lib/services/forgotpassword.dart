import 'package:dogst_ui/components/my_button.dart';
import 'package:dogst_ui/components/textfield.dart';
import 'package:dogst_ui/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  String error = '';

  void resetPassword() async{

    if(emailController.text.isEmpty || !emailController.text.contains("@") || !emailController.text.contains(".com") ) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Incomplete Email"),
          duration: Duration(milliseconds: 600),)
        );
        return;
    }

    try
    {
      await authService.value.resetPassword(email: emailController.text);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email has been sent !"))
        );
      }
      

    }on FirebaseAuthException catch(e){
      error = e.message ?? "Try Again !";
    }

  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            SizedBox(height: height*0.05,),
      
      
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.white,))),
      
            SizedBox(height: height*0.27,),
      
            Center(
              child: const Text(
                "Reset Password 🔐",
                style: TextStyle(fontSize: 30,color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
      
            MyTextField(controller: emailController, hide: false, hintText: "Email"),

            (error.isNotEmpty)?Center(child: Text(error,style: TextStyle(color: Colors.red),)):SizedBox.shrink(),
          

            const SizedBox(height: 40),

            MyButton(icon: Icon(Icons.reset_tv),text: "Reset", onTap: (){
      
              resetPassword();
      
            }),
            ],
        ),
      ),
    );
  }
}
