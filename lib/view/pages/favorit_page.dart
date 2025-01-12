import 'package:coffee_vision/controller/resep_controller.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
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
  bool loading = true;
  late Future<List<Resep>>? fetchFavoritFuture;

  @override
  void initState() {
    super.initState();
    try {
      fetchFavoritFuture = fetchFavorit();
      loading = false;
    } catch (e) {
      showToast(context, "Error: ${{e.toString()}}");
    }
  }

  void refreshResepData() async {}

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
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
                  FutureBuilder<List<Resep>>(
                    future: fetchFavoritFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<Resep> resepList = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: resepList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.67,
                          ),
                          itemBuilder: (context, index) {
                            final resep = resepList[index];
                            return ResepCard(
                              idResep: resep.id,
                              title: resep.title,
                              category: resep.category,
                              imgUrl: resep.imageUrl,
                              rating: resep.rating,
                              idUser: 1,
                              username: resep.username ?? "",
                              userImgUrl: resep.userImgUrl ?? "",
                              createdAt: resep.createdAt,
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailResep(
                                      idResep: resep.id,
                                      rating: resep.rating,
                                      idUser: resep.idUser,
                                      imgUrl: resep.userImgUrl ?? "",
                                    ),
                                  ),
                                ).then((isUpdated) {
                                  if (isUpdated == true) {
                                    setState(() {
                                      fetchFavoritFuture = fetchFavorit();
                                    });
                                  }
                                });
                              },
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Belum ada favorit yang ditambahkan!",
                            style: regularTextStyle.copyWith(fontSize: 16),
                          ),
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
