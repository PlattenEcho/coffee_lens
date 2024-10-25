import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    StorageController storageController = Get.find<StorageController>();
    bool isLoggedIn = storageController.getData('isLoggedIn') ?? false;

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/main-page');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: parentWidth / 3,
            height: parentWidth / 3,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/icon/icon_beranda.png'),
            )),
          ),
        ]),
      ),
    );
  }
}
