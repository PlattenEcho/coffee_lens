import 'dart:io';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final File image;

  const ResultPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "Result",
          style: blackTextStyle.copyWith(fontSize: 24),
        ),
        backgroundColor: kPrimaryLightColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hasil Deteksi",
              style: blackTextStyle.copyWith(fontSize: 24),
            ),
            Text(
              "Pelajari lebih lanjut biji kopi dengan klik tombol di bawah",
              style: mediumTextStyle.copyWith(fontSize: 14),
            ),
            gapH32,
            Center(
                child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPrimaryLight2Color)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            )),
            gapH(48),
            Center(
              child: Column(
                children: [
                  Text(
                    "Robusta",
                    style: blackTextStyle.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Rasa pahit yang tebal dan tinggi kafein ",
                    style: mediumTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            gapH24,
            SizedBox(
              width: double.infinity,
              child: Button(
                bgColor: kPrimaryColor,
                color: kWhiteColor,
                text: "Pelajari lebih lanjut",
                onPressed: () {},
              ),
            ),
            gapH8,
            SizedBox(
              width: double.infinity,
              child: Button(
                bgColor: kWhiteColor,
                color: kPrimaryColor,
                text: "Ke Home Page",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/main-page');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
