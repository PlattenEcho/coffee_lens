import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
          title: Text(
            "Welcome to Coffee Vision!",
            style: blackTextStyle.copyWith(fontSize: 24),
          ),
          backgroundColor: kPrimaryLightColor,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Coba Coffee Vision AI!",
                          style: boldTextStyle.copyWith(
                              color: kWhiteColor, fontSize: 18),
                        ),
                        Text(
                          "Deteksi jenis kopi dengan AI",
                          style: mediumTextStyle.copyWith(fontSize: 14),
                        ),
                        gapH8,
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            backgroundColor: kWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Klik Disini!",
                            style: boldTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/ai_demo.png",
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            gapH12,
            Text(
              "Kenali Kopi Favoritmu!",
              style: boldTextStyle.copyWith(fontSize: 20),
            ),
            Text(
              "Temukan keunikan Arabika dan kekuatan Robusta!",
              style: regularTextStyle.copyWith(fontSize: 14, color: kGreyColor),
            ),
            gapH12,
            ImageCard(
                imageUrl: "assets/robusta.png",
                title: "Robusta",
                desc: "Rasa pahit yang tebal dan tinggi kafein ",
                onTap: () {}),
            gapH8,
            ImageCard(
                imageUrl: "assets/arabika.png",
                title: "Arabika",
                desc: "Cita rasa asam yang lembut dan kompleks ",
                onTap: () {}),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Buat Kopimu Sendiri!",
                  style: boldTextStyle.copyWith(fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    print('Text Clicked');
                  },
                  child: Text(
                    "Lihat Selengkapnya",
                    style: regularTextStyle.copyWith(
                        fontSize: 12, color: kGreyColor),
                  ),
                ),
              ],
            ),
            Text(
              "Dapatkan inspirasi resep kopi yang bisa kamu coba di rumah!",
              style: regularTextStyle.copyWith(fontSize: 14, color: kGreyColor),
            ),
            gapH8,
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
