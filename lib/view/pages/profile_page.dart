import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    radius: 60,
                    backgroundImage: AssetImage("assets/onboarding3.jpg"),
                  ),
                  gapH12,
                  // User Name
                  Text(
                    "User Test",
                    style: blackTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH8,
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  "10",
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            gapH12,
            Text(
              "Resep buatanku nih!",
              style: regularTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            gapH4,
            Text(
              "Menurutku enak sih, gimana menurutmu?",
              style: regularTextStyle.copyWith(
                fontSize: 14,
                color: kGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            gapH(80)
          ],
        ),
      ),
    );
  }
}
