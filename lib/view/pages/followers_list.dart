import 'package:coffee_vision/controller/user_controller.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/card.dart';
import 'package:flutter/material.dart';

class FollowersList extends StatefulWidget {
  final int idUser;
  const FollowersList({super.key, required this.idUser});

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  Future<List<Map<String, dynamic>>>? followersFuture;

  @override
  void initState() {
    super.initState();
    followersFuture = fetchFollowers(widget.idUser);
  }

  Future<void> refreshData() async {
    setState(() {
      followersFuture = fetchFollowers(widget.idUser);
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
            "Followers List",
            style: blackTextStyle.copyWith(fontSize: 24),
          ),
          backgroundColor: kPrimaryLightColor,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: followersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No followers found.'));
            }

            final followers = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: followers.map((follower) {
                  final user = follower['id_follower'];
                  return ProfileCard(
                    idUser: user['id'],
                    username: user['username'],
                    deskripsi: user['deskripsi'] ?? '',
                    imgUrl: user['img_url'] ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OtherProfile(idUser: user['id']),
                        ),
                      ).then((isUnfollowed) {
                        if (isUnfollowed == true || isUnfollowed == false) {
                          refreshData();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
