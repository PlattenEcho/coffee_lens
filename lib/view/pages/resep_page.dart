import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';

class ResepPage extends StatefulWidget {
  const ResepPage({super.key});

  @override
  State<ResepPage> createState() => _ResepPageState();
}

class _ResepPageState extends State<ResepPage> {
  String? selectedCategory;
  String? selectedSort;

  final List<String> categories = ["All", "Espresso", "Latte", "Cappuccino"];
  final List<String> sortOptions = ["Most Popular", "Highest Rated", "Newest"];

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
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH12,
            Row(
              children: [ResepCard(), gapW12, ResepCard()],
            ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
