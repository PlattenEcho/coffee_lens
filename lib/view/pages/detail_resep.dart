import 'dart:io';

import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/pages/update_resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailResep extends StatefulWidget {
  final int idResep;
  final double rating;
  final int idUser;
  final String username;
  final String imgUrl;

  const DetailResep(
      {super.key,
      required this.idResep,
      required this.rating,
      required this.idUser,
      required this.username,
      required this.imgUrl});

  @override
  State<DetailResep> createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
  final userId = storageController.getData("user")['id'];
  bool? isMine;
  double? userRating;
  bool isFavorit = false;
  Recipe? recipe;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
    loadUserRating();
    loadSaved();
    userId == widget.idUser
        ? setState(() {
            isMine = true;
          })
        : isMine = false;

    print("ismine = $isMine");
  }

  Future<void> fetchRecipe() async {
    final response = await supabase
        .from('resep')
        .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
        .eq("id", widget.idResep)
        .single();
    try {
      setState(() {
        recipe = Recipe.fromJson(response);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadUserRating() async {
    final response = await supabase
        .from('rating')
        .select('*')
        .eq('id_resep', widget.idResep)
        .eq('id_user', userId)
        .maybeSingle();

    setState(() {
      if (response != null) {
        userRating = (response['rating'] as num).toDouble();
      } else {
        userRating = 0.0;
      }
    });
  }

  Future<void> loadSaved() async {
    final response = await supabase
        .from('favorit')
        .select('*')
        .eq('id_resep', widget.idResep)
        .eq('id_user', userId)
        .maybeSingle();

    setState(() {
      if (response != null) {
        isFavorit = true;
      } else {
        isFavorit = false;
      }
    });
  }

  Future<void> updateSaved() async {
    try {
      final checkFavorit = await supabase
          .from('favorit')
          .select('*')
          .eq('id_resep', widget.idResep)
          .eq('id_user', userId)
          .maybeSingle();

      if (checkFavorit == null) {
        final response = await supabase.from('favorit').insert({
          'id_resep': widget.idResep,
          'id_user': userId,
        });

        setState(() {
          isFavorit = true;
        });
        showToast(context, "Berhasil menambahkan ke favorit");
      } else {
        final response = await supabase
            .from('favorit')
            .delete()
            .eq('id_resep', widget.idResep)
            .eq('id_user', userId);
        setState(() {
          isFavorit = false;
        });
        showToast(context, "Berhasil menghapus dari favorit");
      }
    } catch (e) {
      print('Error updating favorit: ${e.toString()}');
    }
  }

  Future<void> updateRating(double rating) async {
    try {
      final checkRating = await supabase
          .from('rating')
          .select('*')
          .eq('id_resep', widget.idResep)
          .eq('id_user', userId)
          .maybeSingle();

      if (checkRating == null) {
        final response = await supabase.from('rating').insert({
          'id_resep': widget.idResep,
          'id_user': userId,
          'rating': rating,
        });

        setState(() {
          userRating = rating;
        });
        showToast(context, "Berhasil memberi rating");
      } else {
        final response = await supabase.from('rating').update({
          'rating': rating,
        }).eq('id_resep', widget.idResep);

        setState(() {
          userRating = rating;
        });
        showToast(context, "Berhasil update rating");
      }
    } catch (e) {
      print('Error updating rating: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 250,
            backgroundColor: kPrimaryLight2Color,
            elevation: 0.0,
            flexibleSpace: FlexibleSpaceBar(
                background: recipe == null
                    ? Container(color: kGreyColor)
                    : Image.network(recipe!.imageUrl, fit: BoxFit.cover)),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: kWhiteColor),
            ),
            actions: [
              isMine == true
                  ? PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: kWhiteColor),
                      onSelected: (value) {
                        if (value == 'update') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateResep(
                                      idResep: widget.idResep,
                                    )),
                          );
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Konfirmasi Hapus",
                                  style: boldTextStyle,
                                ),
                                content: Text(
                                  "Apakah Anda yakin ingin menghapus resep ini?",
                                  style: regularTextStyle,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Batal",
                                      style: regularTextStyle,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        await supabase
                                            .from('resep')
                                            .delete()
                                            .eq('id', widget.idResep);
                                        showToast(
                                            context, "Resep berhasil dihapus");
                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(
                                            'Error deleting recipe: ${e.toString()}');
                                      }
                                    },
                                    child: Text(
                                      "Hapus",
                                      style: boldTextStyle.copyWith(
                                          color: kRedColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'update',
                          child: Text('Update'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        updateSaved();
                      },
                      child: Image.asset(
                        isFavorit
                            ? 'assets/icon/icon_favorit_filled.png'
                            : 'assets/icon/icon_favorit.png',
                        width: 24,
                        height: 24,
                        color: kWhiteColor,
                      ),
                    ),
              gapW(16),
            ],
          ),
          recipe == null
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                            width: parentW(context) / 3,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: kPrimaryColor, width: 3),
                              ),
                            ),
                          ),
                          gapH12,
                          Text(
                            recipe!.category,
                            style: mediumTextStyle.copyWith(
                              color: kGreyColor,
                              fontSize: 16,
                            ),
                          ),
                          gapH4,
                          Text(
                            recipe!.title,
                            style: blackTextStyle.copyWith(fontSize: 28),
                          ),
                          gapH8,
                          Text(
                            "Oleh:",
                            style: mediumTextStyle.copyWith(
                              color: kGreyColor,
                              fontSize: 16,
                            ),
                          ),
                          gapH8,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherProfile(idUser: widget.idUser)));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IntrinsicWidth(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage:
                                          NetworkImage(widget.imgUrl),
                                      onBackgroundImageError:
                                          (error, stackTrace) {},
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.username,
                                      style: extraBoldTextStyle.copyWith(
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gapH(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              gapW8,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: kWhiteColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${recipe!.duration} Menit",
                                      style: extraBoldTextStyle.copyWith(
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          gapH(16),
                          Text(
                            recipe!.description,
                            style: regularTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          gapH(16),
                          isMine == false
                              ? userRating != null
                                  ? RatingBar.builder(
                                      initialRating: userRating!,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: kPrimaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        updateRating(
                                            rating); // Save new rating to the database
                                      },
                                    )
                                  : CircularProgressIndicator() // Show loading while waiting for userRating
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      5,
                                      (index) => Icon(
                                            Icons.star,
                                            size: 40,
                                            color: kGreyColor,
                                          )),
                                ),
                          gapH32,
                          TabBar(
                            indicatorColor: kPrimaryColor,
                            labelColor: kPrimaryColor,
                            unselectedLabelColor: kGreyColor,
                            labelStyle: blackTextStyle.copyWith(fontSize: 16),
                            unselectedLabelStyle:
                                blackTextStyle.copyWith(fontSize: 16),
                            tabs: [
                              Tab(
                                text: "Alat dan Bahan",
                              ),
                              Tab(text: "Langkah"),
                            ],
                          ),
                          gapH12,
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                ListView(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  children: [
                                    Text(
                                      "Alat",
                                      style:
                                          blackTextStyle.copyWith(fontSize: 24),
                                    ),
                                    gapH8,
                                    ...recipe!.tools
                                        .map((tool) => AlatCard(nama: tool))
                                        .toList(), // Generate tool cards
                                    gapH(16),
                                    Text(
                                      "Bahan",
                                      style:
                                          blackTextStyle.copyWith(fontSize: 24),
                                    ),
                                    gapH8,
                                    ...recipe!.ingredients
                                        .map((ingredient) => BahanCard(
                                            nama: ingredient.name,
                                            kadar: ingredient.quantity))
                                        .toList(),
                                  ],
                                ),
                                ListView(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  children: [
                                    ...recipe!.steps
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      String step = entry.value;
                                      return StepCard(
                                          nomor: index + 1, langkah: step);
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
        ]),
      ),
    );
  }
}
