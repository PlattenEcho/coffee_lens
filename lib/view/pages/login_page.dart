import 'package:coffee_vision/controller/authentication_controller.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTextColor),
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "Masuk",
          style: blackTextStyle.copyWith(fontWeight: bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH12,
            Text("Masuk untuk Melanjutkan",
                style: boldTextStyle.copyWith(fontSize: 28)),
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
            gapH12,
            Text(
              "Username",
              style: semiBoldTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            gapH4,
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  fillColor: kWhiteColor,
                  hintText: "Masukkan username anda"),
            ),
            gapH8,
            Text(
              "Password",
              style: semiBoldTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            gapH4,
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  fillColor: kWhiteColor,
                  hintText: "Masukkan password anda"),
              obscureText: true,
            ),
            gapH24,
            Button(
              bgColor: kPrimaryColor,
              color: kWhiteColor,
              text: "Masuk",
              onPressed: () async {
                if (passwordController.text.trim().length >= 8) {
                  await authenticateUser(
                    context,
                    usernameController.text.trim(),
                    passwordController.text.trim(),
                  );
                } else {
                  showToast(context, "Password minimal berpanjang 8 karakter");
                }
              },
            ),
            gapH8,
            Center(
              child: RichText(
                  text: TextSpan(
                      style: mediumTextStyle.copyWith(),
                      children: <TextSpan>[
                    const TextSpan(text: "Belum punya akun? "),
                    TextSpan(
                        text: "Daftar di sini",
                        style: blackTextStyle.copyWith(color: kPrimaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, '/register-page');
                          })
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
