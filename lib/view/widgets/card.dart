import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class ResepCard extends StatefulWidget {
  final int idUser;
  final String username;
  final String userImgUrl;
  final int idResep;
  final String imgUrl;
  final String title;
  final String category;
  final double rating;

  const ResepCard(
      {super.key,
      required this.imgUrl,
      required this.userImgUrl,
      required this.username,
      required this.title,
      required this.category,
      required this.rating,
      required this.idUser,
      required this.idResep});

  @override
  State<ResepCard> createState() => _ResepCardState();
}

class _ResepCardState extends State<ResepCard> {
  bool isFavorite = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    if (userId == null) return;
    final response = await supabase
        .from('favorit')
        .select()
        .eq('id_resep', widget.idResep)
        .eq('id_user', userId!);

    setState(() {
      isFavorite = response.isNotEmpty;
    });
  }

  void toggleFavorite() async {
    if (userId == null) return;

    if (isFavorite) {
      await supabase
          .from('favorit')
          .delete()
          .eq('id_resep', widget.idResep)
          .eq('id_user', userId!);
    } else {
      await supabase.from('favorit').insert({
        'id_resep': widget.idResep,
        'id_user': userId,
      });
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailResep(
                  idResep: widget.idResep,
                  rating: widget.rating,
                  idUser: 1,
                  username: "username",
                  imgUrl: "imgUrl")),
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
                    widget.imgUrl,
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
                          widget.rating.toString(),
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
                        widget.title,
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        widget.category,
                        style: regularTextStyle.copyWith(
                          color: kGreyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: toggleFavorite,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kSecondary2Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      isFavorite
                          ? "assets/icon/icon_favorit_filled.png"
                          : "assets/icon/icon_favorit.png",
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

class ProfileCard extends StatelessWidget {
  final String username;
  final String deskripsi;
  final String imgUrl;
  final int idUser;
  final VoidCallback? onTap;

  const ProfileCard(
      {super.key,
      required this.username,
      required this.deskripsi,
      required this.imgUrl,
      required this.idUser,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imgUrl),
                  backgroundColor: kSecondaryColor,
                  onBackgroundImageError: (error, stackTrace) {},
                ),
                gapW12,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      gapH4,
                      Text(
                        deskripsi,
                        style: regularTextStyle.copyWith(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: kGreyColor,
          ),
        ],
      ),
    );
  }
}

class ProfileCard2 extends StatelessWidget {
  final int idUser;
  final String username;
  final String imgUrl;

  const ProfileCard2(
      {super.key,
      required this.idUser,
      required this.username,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtherProfile(idUser: idUser)),
        );
      },
      child: Container(
        width: 90,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imgUrl),
              backgroundColor: kSecondaryColor,
              onBackgroundImageError: (error, stackTrace) {},
            ),
            gapH8,
            Text(
              username,
              style: boldTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            gapH8,
          ],
        ),
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
