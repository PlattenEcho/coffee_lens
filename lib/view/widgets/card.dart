import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class ResepCard extends StatelessWidget {
  final Recipe resep;
  const ResepCard({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailResep(recipe: resep)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPrimaryLight2Color, width: 1.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    resep.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/onboarding1.jpg",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: kYellowColor,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          resep.rating.toString(),
                          style: extraBoldTextStyle.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            gapH8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resep.title,
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        resep.category,
                        style: regularTextStyle.copyWith(
                          color: kGreyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('Favorite icon tapped!');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondary2Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/icon/icon_favorit.png",
                      width: 20,
                      height: 20,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final int nomor;
  final String langkah;
  const StepCard({super.key, required this.nomor, required this.langkah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border.all(color: kPrimaryLight2Color),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step $nomor",
            style: blackTextStyle.copyWith(fontSize: 20),
          ),
          gapH4,
          Text(
            langkah,
            style: regularTextStyle.copyWith(fontSize: 14),
          )
        ],
      ),
    );
  }
}

class AlatCard extends StatelessWidget {
  final String nama;

  const AlatCard({
    super.key,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH4,
        Text(
          nama,
          style: mediumTextStyle.copyWith(fontSize: 16),
        ),
        gapH4,
        Divider(
          thickness: 1,
          color: kGreyColor.withOpacity(0.5), // Warna garis pembatas bawah
        ),
      ],
    );
  }
}

class BahanCard extends StatelessWidget {
  final String nama;
  final String kadar;

  const BahanCard({
    super.key,
    required this.nama,
    required this.kadar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        gapH4,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                nama,
                style: mediumTextStyle.copyWith(fontSize: 16),
              ),
            ]),
            Text(
              kadar,
              style: mediumTextStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
        gapH4,
        Divider(
          thickness: 1,
          color: kGreyColor.withOpacity(0.5), // Warna garis pembatas bawah
        ),
      ],
    );
  }
}
