import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/pages/followers_list.dart';
import 'package:coffee_vision/view/pages/followings_list.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class OtherProfile extends StatefulWidget {
  final int idUser;
  const OtherProfile({super.key, required this.idUser});

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  User? user;
  User? signedUser;
  bool isFollowing = false;
  bool isUnfollowed = false;
  int followersCount = 0;
  int followingCount = 0;
  int resepCount = 0;
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    signedUser = User.fromMap(storageController.getData("user"));
    setFollowStatus();
    getUser();
  }

  Future<void> setFollowStatus() async {
    final response = await supabase
        .from("follows")
        .select("*")
        .eq("id_following", widget.idUser)
        .eq("id_follower", signedUser!.id);

    if (response.isEmpty) {
      setState(() {
        isFollowing = false;
      });
    } else {
      isFollowing = true;
    }
  }

  Future<void> follow() async {
    final response = await supabase.from("follows").insert({
      'id_following': widget.idUser,
      'id_follower': signedUser!.id,
    });

    setState(() {
      isFollowing = true;
      isUnfollowed = false;
      followersCount = followersCount + 1;
    });
  }

  Future<void> unFollow() async {
    final response = await supabase
        .from("follows")
        .delete()
        .eq("id_following", widget.idUser)
        .eq("id_follower", signedUser!.id);

    setState(() {
      isFollowing = false;
      isUnfollowed = true;
      followersCount = followersCount - 1;
    });
  }

  Future<void> getUser() async {
    final userResponse = await supabase
        .from("users")
        .select("*")
        .eq("id", widget.idUser)
        .single();

    final resepResponse =
        await supabase.from("resep").select("*").eq("id_user", widget.idUser);

    final followersResponse = await supabase
        .from("follows")
        .select("*")
        .eq("id_following", widget.idUser)
        .count();

    final followingResponse = await supabase
        .from("follows")
        .select("*")
        .eq("id_follower", widget.idUser)
        .count();

    setState(() {
      recipes = (resepResponse as List).map((recipeData) {
        return Recipe.fromJson(recipeData);
      }).toList();

      user = User.fromMap(userResponse);

      followersCount = followersResponse.count;
      followingCount = followingResponse.count;
      resepCount = resepResponse.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isUnfollowed);
        return false;
      },
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          backgroundColor: kPrimaryLightColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, isUnfollowed);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: user == null
            ? Center(
                child: CircularProgressIndicator(
                color: kPrimaryColor,
              ))
            : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: user!.imgUrl.isNotEmpty
                                ? NetworkImage(user!.imgUrl)
                                : AssetImage("assets/robusta.png")
                                    as ImageProvider,
                            onBackgroundImageError: (error, stackTrace) {},
                          ),
                          gapH(16),
                          Text(
                            user!.username,
                            style: blackTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          gapH4,
                          user!.description.isEmpty
                              ? SizedBox.shrink()
                              : Text(
                                  user!.description,
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
                                        builder: (context) => FollowersList(
                                            idUser: widget.idUser)),
                                  );
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
                                        builder: (context) => FollowingsList(
                                            idUser: widget.idUser)),
                                  );
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
                              Column(
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
                            ],
                          ),
                          gapH4,
                        ],
                      ),
                    ),
                    gapH8,
                    widget.idUser != signedUser?.id
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                if (isFollowing) {
                                  unFollow();
                                } else {
                                  follow();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: isFollowing
                                        ? kSecondaryColor
                                        : kPrimaryLight2Color,
                                    border: Border.all(
                                        width: 1, color: kSecondaryColor),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  isFollowing ? "Following" : "Follow",
                                  style: boldTextStyle.copyWith(
                                      fontSize: 14,
                                      color: isFollowing
                                          ? kWhiteColor
                                          : kTextColor),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
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
                    gapH(80),
                  ],
                ),
              ),
      ),
    );
  }
}
