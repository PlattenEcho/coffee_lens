import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
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
  List<Resep> reseps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResepHomePage();
  }

  Future<void> fetchResepHomePage() async {
    try {
      final response = await supabase
          .from('resep')
          .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        setState(() {
          reseps = [];
        });
        return;
      }

      List<Resep> fetchedReseps = (response as List).map((resepData) {
        return Resep.fromJson(resepData);
      }).toList();

      List<Map<String, dynamic>> resepWithRatings = [];

      for (var resep in fetchedReseps) {
        final ratingsResponse = await supabase
            .from('rating')
            .select('rating')
            .eq('id_resep', resep.id);

        double averageRating = 0.0;
        if (ratingsResponse.isNotEmpty) {
          averageRating = ratingsResponse
                  .map((r) => (r['rating'] as num).toDouble())
                  .reduce((a, b) => a + b) /
              ratingsResponse.length;
        }
        resep.rating = averageRating;

        final userResponse = await supabase
            .from('user')
            .select('username, img_url')
            .eq('id', resep.idUser)
            .maybeSingle();

        if (userResponse != null) {
          resep.username = userResponse['username'];
          resep.userImgUrl = userResponse['img_url'];
        }

        final ratingsCountResponse =
            await supabase.from('rating').select('id').eq('id_resep', resep.id);

        int ratingCount = ratingsCountResponse.length;

        resepWithRatings.add({
          'resep': resep,
          'ratingCount': ratingCount,
        });
      }

      resepWithRatings
          .sort((a, b) => b['ratingCount'].compareTo(a['ratingCount']));

      List<Resep> topReseps = resepWithRatings
          .take(2)
          .map((item) => item['resep'] as Resep)
          .toList();

      setState(() {
        reseps = topReseps;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching home page reseps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
          title: Text(
            "Welcome to Coffee Lens!",
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
                          "Coba Coffee Lens AI!",
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/camera-page');
                          },
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
                imageUrl: "assets/vector_robusta.png",
                title: "Robusta",
                desc: "Rasa pahit yang tebal dan tinggi kafein",
                onTap: () {
                  Navigator.pushNamed(context, "/robusta-page");
                }),
            gapH8,
            ImageCard(
                imageUrl: "assets/vector_arabika.png",
                title: "Arabika",
                desc: "Cita rasa asam yang lembut dan kompleks",
                onTap: () {
                  Navigator.pushNamed(context, "/arabica-page");
                }),
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
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reseps.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.67,
                    ),
                    itemBuilder: (context, index) {
                      final resep = reseps[index];

                      return ResepCard(
                        title: resep.title,
                        category: resep.category,
                        idResep: resep.id,
                        imgUrl: resep.imageUrl,
                        rating: resep.rating,
                        idUser: resep.idUser,
                        userImgUrl: resep.userImgUrl ?? "",
                        username: resep.username ?? "",
                        createdAt: resep.createdAt,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailResep(
                                idResep: resep.id,
                                rating: resep.rating,
                                idUser: resep.idUser,
                                imgUrl: resep.imageUrl,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
