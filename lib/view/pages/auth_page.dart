import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSecondaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kSecondary3Color,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Masuk untuk Melanjutkan",
                    style: whiteTextStyle.copyWith(
                      fontWeight: bold,
                      fontSize: 28,
                    ),
                  ),
                  gapH(8),
                  Text(
                    "Masuk menggunakan username atau buat akun",
                    style: whiteTextStyle.copyWith(
                      color: kGreyColor,
                      fontWeight: light,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  gapH(16),
                  Button(
                    bgColor: kPrimaryColor,
                    color: kWhiteColor,
                    text: "Masuk",
                    onPressed: () {
                      Navigator.pushNamed(context, '/login-page');
                    },
                  ),
                  gapH(12),
                  Button(
                    bgColor: kWhiteColor,
                    color: kPrimaryColor,
                    text: "Daftar",
                    onPressed: () {
                      Navigator.pushNamed(context, '/register-page');
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
