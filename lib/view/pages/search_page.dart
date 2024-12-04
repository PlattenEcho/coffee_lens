import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:flutter/material.dart';
import 'package:coffee_vision/model/recipe.dart';
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
  List<Recipe> recipes = [];
  List<User> users = [];
  List<Recipe> filteredRecipes = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    fetchUsers();
  }

  Future<void> fetchRecipes() async {
    try {
      final response = await supabase
          .from('resep')
          .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)');

      setState(() {
        recipes = (response as List).map((recipeData) {
          return Recipe.fromJson(recipeData);
        }).toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchUsers() async {
    try {
      final response = await supabase
          .from('users')
          .select('id, username, email, created_at, deskripsi, img_url');

      print(
          "Response from users table: $response"); // Debug: tampilkan data mentah dari response

      setState(() {
        users = (response as List).map((userData) {
          return User.fromMap(userData);
        }).toList();
      });

      print(
          "Parsed users list: $users"); // Debug: tampilkan daftar pengguna yang sudah di-parse
    } catch (e) {
      print(
          "Error fetching users: $e"); // Debug: tampilkan error jika gagal mengambil data
    }
  }

  void applySearchFilter() {
    setState(() {
      filteredRecipes = searchQuery.isNotEmpty
          ? recipes.where((recipe) {
              return recipe.title
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList()
          : [];

      filteredUsers = searchQuery.isNotEmpty
          ? users.where((user) {
              return user.username
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList()
          : [];
    });
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
            searchQuery = value;
            applySearchFilter();
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
                  filteredUsers.isNotEmpty
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
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ProfileCard2(
                                      idUser: user.id,
                                      username: user.username,
                                      imgUrl: user.imgUrl,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  gapH12,
                  filteredRecipes.isNotEmpty
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
                              itemCount: filteredRecipes.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.76,
                              ),
                              itemBuilder: (context, index) {
                                final recipe = filteredRecipes[index];
                                return ResepCard(
                                  title: recipe.title,
                                  category: recipe.category,
                                  idResep: recipe.id,
                                  imgUrl: recipe.imageUrl,
                                  rating: 0,
                                  idUser: recipe.idUser,
                                  userImgUrl: "",
                                  username: "aaaa",
                                );
                              },
                            ),
                          ],
                        )
                      : filteredRecipes.isEmpty && filteredUsers.isEmpty
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
