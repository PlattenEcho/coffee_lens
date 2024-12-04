import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/pages/search_page.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';

class ResepPage extends StatefulWidget {
  const ResepPage({super.key});

  @override
  State<ResepPage> createState() => _ResepPageState();
}

class _ResepPageState extends State<ResepPage> {
  String? selectedCategory;
  String? selectedSort;
  String searchQuery = '';
  final List<String> categories = ["All", "Espresso", "Latte", "Cappuccino"];
  final List<String> sortOptions = ["Most Popular", "Highest Rated", "Newest"];

  Future<List<Recipe>> fetchRecipes() async {
    final response = await supabase
        .from('resep')
        .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)');
    return (response as List).map((recipeData) {
      return Recipe.fromJson(recipeData);
    }).toList();
  }

  List<Recipe> applyFilters(List<Recipe> recipes) {
    return recipes.where((recipe) {
      final matchesCategory = selectedCategory == null ||
          selectedCategory == "All" ||
          recipe.category == selectedCategory;
      final matchesSearch =
          recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchRatings(int recipeId) async {
    final response =
        await supabase.from('rating').select('rating').eq('id_resep', recipeId);

    return response as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "Resep",
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: kGreyColor),
                    SizedBox(width: 8),
                    Text("Cari resep atau user disini!",
                        style: regularTextStyle.copyWith(color: kGreyColor)),
                  ],
                ),
              ),
            ),
            gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: Text("Categories", style: regularTextStyle),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: regularTextStyle.copyWith(color: kBlackColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: kWhiteColor,
                ),
                DropdownButton<String>(
                  value: selectedSort,
                  hint: Text("Sort", style: regularTextStyle),
                  items: sortOptions.map((sortOption) {
                    return DropdownMenuItem<String>(
                      value: sortOption,
                      child: Text(
                        sortOption,
                        style: regularTextStyle.copyWith(color: kBlackColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value;
                      // Add your sorting logic here if needed
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: kWhiteColor,
                ),
              ],
            ),
            gapH12,
            FutureBuilder<List>(
              future: fetchRecipes(), // Fetch all recipes initially
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  final recipes = snapshot.data ?? [];
                  return GridView.builder(
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
                      return FutureBuilder<List>(
                        future: fetchRatings(recipe.id),
                        builder: (context, ratingSnapshot) {
                          double averageRating = 0.0;
                          if (ratingSnapshot.hasData &&
                              ratingSnapshot.data!.isNotEmpty) {
                            final ratings = ratingSnapshot.data!;
                            averageRating = ratings
                                    .map((r) => (r['rating'] as num).toDouble())
                                    .reduce((a, b) => a + b) /
                                ratings.length;
                          }
                          return ResepCard(
                            title: recipe.title,
                            category: recipe.category,
                            idResep: recipe.id,
                            imgUrl: recipe.imageUrl,
                            rating: averageRating,
                            idUser: 1,
                            userImgUrl: "",
                            username: "Unknown",
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
