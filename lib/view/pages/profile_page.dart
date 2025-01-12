import 'package:coffee_vision/controller/resep_controller.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/pages/followers_list.dart';
import 'package:coffee_vision/view/pages/followings_list.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> user;
  int followersCount = 0;
  int followingCount = 0;
  int resepCount = 0;
  late Future<List<Resep>>? fetchUserResepFuture;

  @override
  void initState() {
    super.initState();
    user = storageController.getData("user");
    getCount();
    fetchUserResepFuture = fetchUserReseps(user['id']);
  }

  Future<void> getCount() async {
    final responses = await Future.wait([
      supabase
          .from("follow")
          .select("*")
          .eq("id_following", user['id'])
          .count(),
      supabase.from("follow").select("*").eq("id_follower", user['id']).count(),
      supabase.from("resep").select("*").eq("id_user", user['id']).count(),
    ]);

    setState(() {
      followersCount = responses[0].count;
      followingCount = responses[1].count;
      resepCount = responses[2].count;
    });
  }

  void refreshResepData() async {
    setState(() {
      fetchUserResepFuture = fetchUserReseps(user['id']);
    });
  }

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
          "Profile",
          style: blackTextStyle.copyWith(fontSize: 24),
        ),
        backgroundColor: kPrimaryLightColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/setting-page');
              },
              icon: Icon(
                Icons.settings,
                color: kTextColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: kSecondaryColor,
                    radius: 60,
                    backgroundImage:
                        user['img_url'] != null && user['img_url'].isNotEmpty
                            ? NetworkImage(user['img_url'])
                            : AssetImage("assets/robusta.png"),
                    onBackgroundImageError: (error, stackTrace) {},
                  ),
                  gapH(16),
                  Text(
                    user['username'],
                    style: blackTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH4,
                  user['deskripsi'] == ""
                      ? SizedBox.shrink()
                      : Text(
                          user['deskripsi'],
                          style: regularTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                  gapH(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FollowersList(idUser: user['id']),
                            ),
                          ).then((updated) {
                            if (updated == true) {
                              getCount();
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "Followers",
                              style: regularTextStyle.copyWith(
                                color: kGreyColor,
                                fontSize: 14,
                              ),
                            ),
                            gapH4,
                            Text(
                              followersCount.toString(),
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapW(16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FollowingsList(idUser: user['id']),
                            ),
                          ).then((updated) {
                            if (updated == true) {
                              getCount();
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              "Followings",
                              style: regularTextStyle.copyWith(
                                color: kGreyColor,
                                fontSize: 14,
                              ),
                            ),
                            gapH4,
                            Text(
                              followingCount.toString(),
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapW(16),
                      GestureDetector(
                        child: Column(
                          children: [
                            Text(
                              "Resep",
                              style: regularTextStyle.copyWith(
                                color: kGreyColor,
                                fontSize: 14,
                              ),
                            ),
                            gapH4,
                            Text(
                              resepCount.toString(),
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  gapH4,
                ],
              ),
            ),
            gapH8,
            gapH24,
            Text(
              "Resep buatanku nih!",
              style: boldTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            gapH4,
            Text(
              "Cobain dulu, siapa tahu kamu suka!",
              style: regularTextStyle.copyWith(
                fontSize: 14,
                color: kGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            gapH(16),
            FutureBuilder<List<Resep>>(
              future: fetchUserResepFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Resep> resepList = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: resepList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        idUser: user['id'],
                        username: user['username'],
                        userImgUrl: user['img_url'],
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
                              refreshResepData();
                            }
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Tidak ada resep yang tersedia"));
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
