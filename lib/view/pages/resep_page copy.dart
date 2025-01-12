import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
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
  late Future<List<Resep>>? fetchResepFuture;

  @override
  void initState() {
    super.initState();
    try {
      fetchResepFuture = getSortedAndFilteredReseps();
    } catch (e) {
      showToast(context, "Error: ${{e.toString()}}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Resep>> fetchReseps() async {
    final response = await supabase
        .from('resep')
        .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
        .order("created_at", ascending: false);

    if (response.isEmpty) {
      setState(() {});
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
    return reseps;
  }

  List<Resep> applyFilters(List<Resep> reseps) {
    return reseps.where((resep) {
      final matchesCategory = selectedCategory == null ||
          selectedCategory == "All" ||
          resep.category == selectedCategory;
      final matchesSearch =
          resep.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<List<Resep>> applySorting(List<Resep> reseps) async {
    if (selectedSort == "Most Popular") {
      List<Map<String, dynamic>> resepsWithCount = await Future.wait(
        reseps.map((resep) async {
          int count = await getRatingCount(resep.id);
          return {'resep': resep, 'ratingCount': count};
        }),
      );
      resepsWithCount
          .sort((a, b) => b['ratingCount'].compareTo(a['ratingCount']));
      return resepsWithCount.map((e) => e['resep'] as Resep).toList();
    }

    if (selectedSort == "Highest Rated") {
      List<Map<String, dynamic>> resepsWithRatings = await Future.wait(
        reseps.map((resep) async {
          final ratings = await fetchRatings(resep.id);
          double averageRating = 0.0;
          if (ratings.isNotEmpty) {
            averageRating = ratings
                    .map((r) => (r['rating'] as num).toDouble())
                    .reduce((a, b) => a + b) /
                ratings.length;
          }
          return {'resep': resep, 'averageRating': averageRating};
        }),
      );

      resepsWithRatings
          .sort((a, b) => b['averageRating'].compareTo(a['averageRating']));
      return resepsWithRatings.map((e) => e['resep'] as Resep).toList();
    }

    if (selectedSort == "Newest") {
      reseps.sort((a, b) => b.id.compareTo(a.id));
    }

    return reseps;
  }

  Future<List<Resep>> getSortedAndFilteredReseps() async {
    final reseps = await fetchReseps();
    final filteredReseps = applyFilters(reseps);
    return await applySorting(filteredReseps);
  }

  Future<List<Map<String, dynamic>>> fetchRatings(int resepId) async {
    final response =
        await supabase.from('rating').select('rating').eq('id_resep', resepId);

    return response as List<Map<String, dynamic>>;
  }

  Future<int> getRatingCount(int resepId) async {
    final response = await supabase
        .from('rating')
        .select('id')
        .eq('id_resep', resepId)
        .count();

    return response.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text("Resep", style: blackTextStyle.copyWith(fontSize: 24)),
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
                  MaterialPageRoute(builder: (context) => SearchPage()),
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
                      child: Text(category,
                          style: regularTextStyle.copyWith(color: kBlackColor)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      fetchResepFuture = getSortedAndFilteredReseps();
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
                      child: Text(sortOption,
                          style: regularTextStyle.copyWith(color: kBlackColor)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value;
                      fetchResepFuture = getSortedAndFilteredReseps();
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: kWhiteColor,
                ),
              ],
            ),
            gapH12,
            FutureBuilder<List<Resep>>(
              future: fetchResepFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: kPrimaryColor));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No resep found"));
                } else {
                  final reseps = snapshot.data!;
                  return GridView.builder(
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
                          ).then((isUpdated) {
                            if (isUpdated == true) {
                              setState(() {
                                fetchResepFuture = getSortedAndFilteredReseps();
                              });
                            }
                          });
                          ;
                        },
                      );
                    },
                  );
                }
              },
            ),
            gapH(120)
          ],
        ),
      ),
    );
  }
}
