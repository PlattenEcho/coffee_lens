import 'dart:async';

import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:flutter/material.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  List<Resep> resep = [];
  List<User> user = [];

  Timer? debounce;
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchReseps(String keyword) async {
    try {
      final response = await supabase
          .from('resep')
          .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
          .ilike('title', '%$keyword%');

      if (response.isEmpty) {
        setState(() {
          resep = [];
        });
        return;
      }

      List<Resep> reseps = (response as List).map((resepData) {
        return Resep.fromJson(resepData);
      }).toList();

      for (var resep in reseps) {
        final ratings = await supabase
            .from('rating')
            .select('rating')
            .eq('id_resep', resep.id);
        double averageRating = 0.0;
        if (ratings.isNotEmpty) {
          averageRating = ratings
                  .map((r) => (r['rating'] as num).toDouble())
                  .reduce((a, b) => a + b) /
              ratings.length;
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
      }

      setState(() {
        resep = reseps;
      });
    } catch (e) {
      print("Error fetching reseps: $e");
    }
  }

  Future<void> fetchUsers(String keyword) async {
    try {
      final response = await supabase
          .from('user')
          .select('id, username, email, created_at, deskripsi, img_url')
          .ilike('username', '%$keyword%');

      setState(() {
        user = (response as List).map((userData) {
          return User.fromMap(userData);
        }).toList();
      });
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  void applySearchFilter() {
    if (searchQuery.isNotEmpty) {
      fetchReseps(searchQuery);
      fetchUsers(searchQuery);
    } else {
      setState(() {
        resep = [];
        user = [];
      });
    }
  }

  void applySearchFilterWithDebounce(String value) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = value;
      });
      applySearchFilter();
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search, color: kGreyColor),
            filled: true,
            fillColor: kWhiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            applySearchFilterWithDebounce(value);
          },
        ),
        iconTheme: IconThemeData(color: kBlackColor),
      ),
      body: searchQuery.isEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  gapH24,
                  Center(
                    child: Text(
                      "Ketik untuk mencari resep atau pengguna",
                      style: mediumTextStyle.copyWith(
                          fontSize: 14, color: kGreyColor),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  user.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User",
                              style: blackTextStyle.copyWith(fontSize: 24),
                            ),
                            gapH12,
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: user.length,
                                itemBuilder: (context, index) {
                                  final pengguna = user[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ProfileCard2(
                                      idUser: pengguna.id,
                                      username: pengguna.username,
                                      imgUrl: pengguna.imgUrl,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  gapH12,
                  resep.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Resep",
                              style: blackTextStyle.copyWith(fontSize: 24),
                            ),
                            gapH12,
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: resep.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.65,
                              ),
                              itemBuilder: (context, index) {
                                final recipe = resep[index];
                                return ResepCard(
                                  title: recipe.title,
                                  category: recipe.category,
                                  idResep: recipe.id,
                                  imgUrl: recipe.imageUrl,
                                  rating: recipe.rating,
                                  idUser: recipe.idUser,
                                  userImgUrl: recipe.userImgUrl ?? "",
                                  username: recipe.username ?? "",
                                  createdAt: recipe.createdAt,
                                  onClick: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailResep(
                                          idResep: recipe.id,
                                          rating: recipe.rating,
                                          idUser: recipe.idUser,
                                          imgUrl: recipe.imageUrl,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      : resep.isEmpty && user.isEmpty
                          ? Center(
                              child: Text(
                                "Tidak ditemukan",
                                style: mediumTextStyle.copyWith(
                                    fontSize: 18, color: kGreyColor),
                              ),
                            )
                          : SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
