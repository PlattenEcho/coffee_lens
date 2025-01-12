import 'dart:convert';
import 'dart:io';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  final File image;

  const ResultPage({super.key, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int Result = 0;
  String? coffeeType;
  String? coffeeDescription;
  Future<void> classifyImage() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.56.1:5000/predict'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file', widget.image.path),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        setState(() {
          if (data['class'] == 'robusta') {
            coffeeType = "Robusta";
            coffeeDescription = "Rasa pahit yang tebal dan tinggi kafein";
          } else if (data['class'] == 'arabica') {
            coffeeType = "Arabica";
            coffeeDescription = "Cita rasa asam yang lembut dan kompleks";
          }
        });
      } else {
        setState(() {
          coffeeType = 'Error';
          coffeeDescription = 'Failed to predict coffee type.';
        });
      }
    } catch (e) {
      setState(() {
        coffeeType = 'Error';
        coffeeDescription = 'An error occurred while uploading the image.';
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    classifyImage();
  }

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
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            )),
            gapH(48),
            Center(
              child: Column(
                children: [
                  Text(
                    coffeeType ??
                        "Loading...", // Display coffee type or "Loading..."
                    style: blackTextStyle.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    coffeeDescription ?? "Please wait...",
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
                onPressed: () {
                  coffeeType == null
                      ? showToast(context, "Loading")
                      : coffeeType == "Robusta"
                          ? Navigator.pushNamed(context, "/robusta-page")
                          : Navigator.pushNamed(context, "/arabica-page");
                },
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
