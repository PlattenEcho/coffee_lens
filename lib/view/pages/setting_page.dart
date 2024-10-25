import 'package:coffee_vision/controller/authentication_controller.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          title: Text(
            "Setting",
            style: blackTextStyle.copyWith(fontSize: 24),
          ),
          backgroundColor: kPrimaryLightColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SettingButton(
                title: 'Edit profil',
                onTap: () {},
                desc: 'Ubah username atau foto profil',
              ),
              gapH24,
              Button(
                  bgColor: kRedColor,
                  color: kWhiteColor,
                  text: "Log Out",
                  onPressed: () {
                    logout(context);
                  })
            ],
          ),
        ));
  }
}
