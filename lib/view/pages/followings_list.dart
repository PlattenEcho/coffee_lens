import 'package:coffee_vision/controller/user_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FollowingsList extends StatefulWidget {
  final int idUser;
  const FollowingsList({super.key, required this.idUser});

  @override
  State<FollowingsList> createState() => _FollowingsListState();
}

class _FollowingsListState extends State<FollowingsList> {
  Future<List<Map<String, dynamic>>>? followingsFuture;

  @override
  void initState() {
    super.initState();
    followingsFuture = fetchFollowings(widget.idUser);
  }

  Future<void> refreshData() async {
    setState(() {
      followingsFuture = fetchFollowings(widget.idUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          title: Text(
            "Following List",
            style: blackTextStyle.copyWith(fontSize: 24),
          ),
          backgroundColor: kPrimaryLightColor,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: followingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Belum ada akun yang difollow.'));
            }

            final followings = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: followings.map((following) {
                  final user = following['id_following'];
                  return ProfileCard(
                      idUser: user['id'],
                      username: user['username'],
                      deskripsi: user['deskripsi'] ?? '',
                      imgUrl: user['img_url'] ?? '',
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OtherProfile(idUser: user['id']),
                          ),
                        ).then((isUnfollowed) {
                          if (isUnfollowed == true) {
                            refreshData();
                          }
                        });
                      });
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
