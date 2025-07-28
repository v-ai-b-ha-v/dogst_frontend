import 'package:dogst_ui/pages/userinitialroute.dart';
import 'package:dogst_ui/usage/permissioncheck.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:dogst_ui/pages/homepage.dart';


class PermissionLayout extends StatefulWidget {
  const PermissionLayout({super.key});

  @override
  State<PermissionLayout> createState() => _PermissionLayoutState();
}

class _PermissionLayoutState extends State<PermissionLayout> {
  bool? hasPermission;

  @override
  void initState() {
    super.initState();
    _checkUsagePermission();
  }

  Future<void> _checkUsagePermission() async {
    bool granted = await UsageStats.checkUsagePermission()??false;
    setState(() {
      hasPermission = granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasPermission == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return hasPermission!
        ?  UserInitRouterPage()
        :  UsagePermissionPage(onPermissionGranted: _checkUsagePermission,);
  }
}
