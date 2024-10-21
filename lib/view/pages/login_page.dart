import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              decoration: InputDecoration(
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  fillColor: kWhiteColor,
                  hintText: "Masukkan username anda"),
              obscureText: true,
            ),
            gapH24,
            Button(
              bgColor: kPrimaryColor,
              color: kWhiteColor,
              text: "Masuk",
              onPressed: () {
                Navigator.pushNamed(context, "/main-page");
              },
            ),
          ],
        ),
      ),
    );
  }
}
