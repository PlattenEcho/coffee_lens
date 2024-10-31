import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
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
  List<Recipe> recipes = [];

  final List<String> categories = ["All", "Espresso", "Latte", "Cappuccino"];
  final List<String> sortOptions = ["Most Popular", "Highest Rated", "Newest"];

  @override
  void initState() {
    super.initState();
    fetchRecipes(); // Fetch recipes on page load
  }

  Future<void> fetchRecipes() async {
    final response = await supabase
        .from('resep')
        .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)');
    try {
      setState(() {
        recipes = (response as List).map((recipeData) {
          return Recipe.fromJson(recipeData); // Convert JSON to Recipe model
        }).toList();
      });
    } catch (e) {
      print(e.toString());
      showToast(context, "Failed to load recipes: ${e.toString()}");
    }
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
            TextField(
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
                // Add your search logic here
              },
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
                      // Add your category filter logic here
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
                      // Add your sorting logic here
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: kWhiteColor,
                ),
              ],
            ),
            gapH12,
            recipes.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.76),
                    itemBuilder: (context, index) {
                      return ResepCard(resep: recipes[index]);
                    },
                  ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
