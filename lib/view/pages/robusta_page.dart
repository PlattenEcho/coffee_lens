import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class RobustaPage extends StatelessWidget {
  const RobustaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "All About Robusta",
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
              "Robusta",
              style: blackTextStyle.copyWith(
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              "Coffea canephora var. Robusta",
              style: mediumTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                color: kGreyColor,
              ),
            ),
            gapH(10),
            Center(
              child: Image.asset(
                "assets/robusta.png",
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            gapH(16),
            Text(
              'Nama Robusta berasal dari kata "robust", yang berarti "kuat". Kopi ini dikenal dengan cita rasa yang kuat dan cenderung lebih pahit dibandingkan kopi Arabica.',
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
                'Biji Robusta cenderung bulat dengan lipatan tengah yang lurus, lebih kecil dan padat dibandingkan biji Arabica.',
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
            gapH12,
            Text(
              'Kopi Robusta tumbuh subur di iklim tropis dengan suhu hangat. Lebih tangguh dibanding Arabica, Robusta bisa tumbuh di dataran rendah maupun pegunungan, serta tahan terhadap cuaca ekstrem dan curah hujan tinggi.Robusta tumbuh pada ketinggian 400–700 meter di atas permukaan laut, dengan suhu optimal 21-24 °C, dan membutuhkan musim kering selama 3-4 bulan. Kopi Robusta menyumbang sekitar 40-45% dari produksi kopi dunia. Wilayah produksi antara lain: ',
              style: regularTextStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            gapH8,
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(
                    "Jawa Timur",
                    style: boldTextStyle.copyWith(),
                  ),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text(
                    "Bali",
                    style: boldTextStyle.copyWith(),
                  ),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text(
                    "Lampung",
                    style: boldTextStyle.copyWith(),
                  ),
                  backgroundColor: kPrimaryLight2Color,
                ),
                Chip(
                  label: Text(
                    "Nusa Tenggara Timur",
                    style: boldTextStyle.copyWith(),
                  ),
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
            gapH12,
            Row(
              children: [
                Icon(Icons.coffee, color: kSecondaryColor, size: 28),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Biji Robusta memiliki rasa yang lebih pahit dan kuat, serta umumnya digunakan dalam kopi komersial seperti kopi instan.',
                    style: regularTextStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            gapH8,
            Row(
              children: [
                Icon(Icons.coffee_maker, color: kSecondaryColor, size: 28),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Kafein dalam Robusta mencapai 2-2.7%, hampir dua kali lipat dari Arabica, membuatnya lebih tahan hama dan memiliki rasa yang lebih kuat.',
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
            gapH12,
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
                    "Robusta Wet Process",
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  gapH8,
                  Text(
                    'Proses ini melibatkan air sebagai komponen utama. Biji kopi dipilih yang matang, dikupas, dan dicuci untuk mendapatkan kopi berkualitas tinggi. Meski prosesnya mahal, metode ini menghasilkan biji kopi yang padat dan bersih dengan waktu pengeringan yang singkat.',
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
                    "Robusta Dry Process",
                    style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  gapH8,
                  Text(
                    'Buah kopi dikeringkan tanpa pengupasan terlebih dahulu menggunakan sinar matahari. Robusta Dry Process membutuhkan ruang dan waktu lebih lama karena bergantung pada cuaca. Kopi yang dihasilkan cenderung lebih murah dan cocok untuk biji dengan kualitas rendah.',
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
