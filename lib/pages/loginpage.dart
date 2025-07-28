import 'package:dogst_ui/components/my_button.dart';
import 'package:dogst_ui/components/square_tile.dart';
import 'package:dogst_ui/components/textfield.dart';
import 'package:dogst_ui/pages/registerpage.dart';
import 'package:dogst_ui/services/auth_layout.dart';
import 'package:dogst_ui/services/auth_service.dart';
import 'package:dogst_ui/services/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String error = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void googleSignIn() async{

    final userCredential = await authService.value.signInWithGoogle();

    if(userCredential != null){

      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthLayout(pageIsNotConnected: RegisterPage())));
      }

    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google SignIn failed"))
        );
      }
    }

  }

  void signIn() async {
    try {
      await authService.value.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => AuthLayout(pageIsNotConnected: RegisterPage()),
          ),
        ); // or use MaterialPageRoute
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "Error encountered";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/login_background.json',
            fit: BoxFit.cover,
            height: height,
            width: width,
            alignment: Alignment.center, // fills the screen without distortion
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.08),

                Center(
                  child: Image.asset(
                    'lib/images/logo.png',
                    height: 200,
                    width: 200,
                  ),
                ),

                SizedBox(height: height * 0.03),

                Text(
                  "Welcome back user",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
                ),

                SizedBox(height: height * 0.03),

                MyTextField(
                  controller: emailController,
                  hintText: "Email...",
                  hide: false,
                ),

                SizedBox(height: height * 0.01),

                MyTextField(
                  controller: passwordController,
                  hintText: "Password ...",
                  hide: true,
                ),

                (error.isNotEmpty)?Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(error, style: TextStyle(color: Colors.red)),
                ):SizedBox.shrink(),

                Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.1,
                   
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),
                MyButton(icon : Icon(Icons.login, color: Colors.white),onTap: signIn, text: "SignIn"),

                SizedBox(height: height * 0.02),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(onTap: () {
                      googleSignIn();
                    }, img: "lib/images/google.png"),
                  ],
                ),

                SizedBox(height: height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: width * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Register Now !",
                        style: TextStyle(color: Colors.blue.shade300),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
