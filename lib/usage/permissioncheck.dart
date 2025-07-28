import 'package:dogst_ui/pages/homepage.dart';
import 'package:dogst_ui/pages/userinitialroute.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';


class UsagePermissionPage extends StatefulWidget {
  const UsagePermissionPage({super.key,

    required this.onPermissionGranted
  });

  final VoidCallback? onPermissionGranted;

  @override
  State<UsagePermissionPage> createState() => _UsagePermissionPageState();
}

class _UsagePermissionPageState extends State<UsagePermissionPage> {
  bool _isChecking = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkUsagePermission();
  }

  Future<void> checkUsagePermission() async {
    bool granted = await UsageStats.checkUsagePermission()?? false;
    if (granted) {
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  UserInitRouterPage()),
        );
      }
    } else {
      setState(() {
        _isChecking = false;
        _hasPermission = false;
      });
    }
  }

  void requestPermission() {
    UsageStats.grantUsagePermission();
  }

  void onPermissionConfirmed() {
    setState(() {
      _isChecking = true;
    });
    checkUsagePermission();
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Usage Access Required")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "📱 To continue, we need permission to track screen usage.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: requestPermission,
              child: const Text("Grant Usage Access"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onPermissionConfirmed,
              child: const Text("I have granted permission"),
            ),
          ],
        ),
      ),
    );
  }
}
