import 'package:dogst_ui/components/my_button.dart';
import 'package:dogst_ui/components/square_tile.dart';
import 'package:dogst_ui/components/textfield.dart';
import 'package:dogst_ui/pages/loginpage.dart';
import 'package:dogst_ui/services/auth_layout.dart';
import 'package:dogst_ui/services/auth_service.dart';
import 'package:dogst_ui/services/emailVerify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String errorMessage = '';

  @override
  void dispose(){
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
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

  void registerUser() async{
    
    try{
      if (confirmPasswordController.text.trim() != passwordController.text.trim()) {
        confirmPasswordController.clear();
        passwordController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords didn't matched !!",style: TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: Duration(milliseconds: 400),));
      return;
    }



    await authService.value.createAccount(
      email: emailController.text,
      password: passwordController.text,
    );

    await authService.value.currentUser!.sendEmailVerification();

    if(mounted){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailVerificationPage()));
    }



    } on FirebaseAuthException catch(e){
      setState(() {
        errorMessage = e.message ?? "There is an error";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          
          Lottie.asset(
            'assets/register_background.json',
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
                height: 150,
                width: 150,
              ),
            ),

            SizedBox(height: height * 0.03),

            Text("Lets create an Account", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color :Colors.white)),

            SizedBox(height: height * 0.03),

            MyTextField(
              controller: emailController,
              hintText: "Email....",
              hide: false,
            ),

            SizedBox(height: height * 0.01),

            MyTextField(
              controller: passwordController,
              hintText: "Password ...",
              hide: true,
            ),

            SizedBox(height: height * 0.01),

            MyTextField(
              controller: confirmPasswordController,
              hintText: "Confirm Password ...",
              hide: true,
            ),

            SizedBox(height: height * 0.015),

            (errorMessage.isNotEmpty)?Center(child: Text(errorMessage, style: TextStyle(color: Colors.red),)):SizedBox.shrink(),

            SizedBox(height: height * 0.015),

            MyButton(icon: Icon(Icons.app_registration, color: Colors.white),onTap: registerUser, text: "SignUp"),

            SizedBox(height: height * 0.02),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey.shade400),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Or continue with",style: TextStyle(color: Colors.white),),
                  ),
                  Expanded(
                    child: Divider(thickness: 0.5, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.01),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(onTap: (){
                  googleSignIn();
                }, img: "lib/images/google.png"),
              ],
            ),

            SizedBox(height: height * 0.01),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",style: TextStyle(color: Colors.white),),
                SizedBox(width: width * 0.02),
                GestureDetector(
                  onTap: (){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

                  },
                  child: Text(
                    "Login Now !",
                    style: TextStyle(color: const Color.fromARGB(255, 62, 121, 188)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        ],
      )
    );
  }
}
