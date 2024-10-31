import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class ArabicaPage extends StatelessWidget {
  const ArabicaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "All About Arabika",
          style: blackTextStyle.copyWith(
              fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Section with Image
            Text(
              "Arabika",
              style: blackTextStyle.copyWith(
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              "Coffea arabica",
              style: mediumTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                color: kGreyColor,
              ),
            ),
            gapH(10),
            Center(
              child: Image.asset(
                "assets/arabika.png",
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            gapH(16),
            Text(
              'Arabika adalah jenis kopi yang paling populer di dunia, dikenal dengan cita rasa yang lebih halus dan kompleks dibandingkan dengan Robusta.',
              style: regularTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            gapH(8),
            Container(
              decoration: BoxDecoration(
                color: kPrimaryLight2Color,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                'Biji Arabika biasanya lebih besar dan berbentuk oval dengan lipatan tengah yang berliku, berbeda dengan Robusta.',
                style: regularTextStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ),

            // Wilayah Produksi Section with Divider
            gapH(20),
            Divider(thickness: 2, color: Colors.grey[300]),
            Text(
              "Wilayah Produksi",
              style: boldTextStyle.copyWith(fontSize: 24),
            ),
            gapH8,
            Text(
              'Arabika tumbuh di ketinggian yang lebih tinggi dibandingkan Robusta dan membutuhkan iklim yang sejuk. Wilayah produksi utamanya meliputi: ',
              style: regularTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            gapH8,
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text("Sumatera"),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text("Sulawesi"),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text("Bali"),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text("Aceh"),
                  backgroundColor: kPrimaryLight2Color,
                ),
              ],
            ),

            // Karakter & Rasa Section with Iconography
            gapH(20),
            Divider(thickness: 2, color: Colors.grey[300]),
            Text(
              "Karakter & Rasa",
              style: boldTextStyle.copyWith(fontSize: 24),
            ),
            gapH8,
            Row(
              children: [
                Icon(Icons.coffee, color: kSecondary2Color, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Arabika memiliki rasa yang lebih halus dan beragam, seringkali dengan aroma buah atau bunga yang kompleks.',
                    style: regularTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            gapH8,
            Row(
              children: [
                Icon(Icons.coffee_maker, color: kSecondary2Color, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kafein dalam Arabika lebih rendah, sekitar 1-1.5%, membuat rasanya lebih lembut dan tidak terlalu pahit dibandingkan Robusta.',
                    style: regularTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Metode Pengolahan Section with Highlighted Boxes
            gapH(20),
            Divider(thickness: 2, color: Colors.grey[300]),
            Text(
              "Metode Pengolahan",
              style: boldTextStyle.copyWith(fontSize: 24),
            ),
            gapH8,
            Container(
              decoration: BoxDecoration(
                color: kPrimaryLight2Color,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Arabika Washed Process",
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  gapH8,
                  Text(
                    'Dalam proses ini, biji kopi dicuci dengan air untuk menghilangkan lapisan lendir dan kulitnya, menghasilkan kopi dengan rasa yang lebih bersih dan cerah.',
                    style: regularTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            gapH8,
            Container(
              decoration: BoxDecoration(
                color: kPrimaryLight2Color,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Arabika Natural Process",
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  gapH8,
                  Text(
                    'Buah kopi dibiarkan mengering alami bersama kulitnya, memberikan rasa yang lebih manis dan kompleks pada biji Arabika.',
                    style: regularTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
