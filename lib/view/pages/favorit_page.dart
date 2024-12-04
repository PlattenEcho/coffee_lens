import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  List<Recipe> recipes = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    int userId = storageController.getData("user")['id'];

    try {
      final response = await supabase
          .from('favorit')
          .select('*, resep(*)')
          .eq('id_user', userId);

      setState(() {
        recipes = (response as List).map((favoriteData) {
          return Recipe.fromJson(favoriteData['resep']);
        }).toList();
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

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
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              color: kPrimaryColor,
            ))
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  recipes.isEmpty
                      ? Center(
                          child: Text(
                            "Belum ada favorit yang ditambahkan!",
                            style: regularTextStyle.copyWith(fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipes.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.76,
                          ),
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];

                            return FutureBuilder(
                              future: supabase
                                  .from("rating")
                                  .select("rating")
                                  .eq("id_resep", recipe.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox.shrink();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    (snapshot.data as List).isEmpty) {
                                  return SizedBox.shrink();
                                } else {
                                  final ratings = snapshot.data as List;
                                  final averageRating = ratings.isNotEmpty
                                      ? ratings
                                              .map((r) => (r['rating'] as num)
                                                  .toDouble())
                                              .reduce((a, b) => a + b) /
                                          ratings.length
                                      : 0.0;

                                  return ResepCard(
                                    title: recipe.title,
                                    category: recipe.category,
                                    idResep: recipe.id,
                                    imgUrl: recipe.imageUrl,
                                    rating: averageRating,
                                    idUser: recipe.idUser,
                                    userImgUrl: "",
                                    username: "",
                                  );
                                }
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
