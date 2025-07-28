
import 'package:dogst_ui/pages/homepage.dart';
import 'package:dogst_ui/pages/registerpage.dart';
import 'package:dogst_ui/services/apploading.dart';
import 'package:dogst_ui/services/auth_service.dart';
import 'package:dogst_ui/usage/permission_layout.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key,
  required this.pageIsNotConnected
  });

  final Widget? pageIsNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService, 
      builder: (context, authService, child){
        
        return StreamBuilder(stream: authService.authStateChanges,
         builder: (context,snapshot){

          Widget widget;

          if(snapshot.connectionState == ConnectionState.waiting){
            widget = AppLoadingPage();
          }
          else if(snapshot.hasData && authService.currentUser!.emailVerified){
            widget = PermissionLayout();
          }else{
            widget = pageIsNotConnected ??  RegisterPage();
          }

          return widget;          

         });
      });
  }
}