import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "Favorit",
          style: blackTextStyle.copyWith(fontSize: 24),
        ),
        backgroundColor: kPrimaryLightColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH12,
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH12,
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH12,
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
