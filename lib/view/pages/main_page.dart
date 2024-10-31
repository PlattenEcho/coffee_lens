import 'package:coffee_vision/controller/cubit.dart';
import 'package:coffee_vision/view/pages/camera_page.dart';
import 'package:coffee_vision/view/pages/favorit_page.dart';
import 'package:coffee_vision/view/pages/home_page.dart';
import 'package:coffee_vision/view/pages/profile_page.dart';
import 'package:coffee_vision/view/pages/resep_page.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/custom_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildContent(int currentIndex) {
      switch (currentIndex) {
        case 0:
          return HomePage();
        case 1:
          return ResepPage();
        case 2:
          return CameraPage();
        case 3:
          return FavoritPage();
        case 4:
          return ProfilePage();
        default:
          return HomePage();
      }
    }

    Widget customNavBar() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(color: kPrimaryLight2Color, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                spreadRadius: 10,
                offset: const Offset(0, 0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomNavBarItem(
                  index: 0,
                  imageUrl: "assets/icon/icon_beranda.png",
                  text: "Beranda"),
              CustomNavBarItem(
                  index: 1,
                  imageUrl: "assets/icon/icon_resep.png",
                  text: "Resep"),
              CustomNavBarItem2(
                index: 2,
                imageUrl: "assets/icon/icon_camera.png",
              ),
              CustomNavBarItem(
                  index: 3,
                  imageUrl: "assets/icon/icon_favorit.png",
                  text: "Favorit"),
              CustomNavBarItem(
                  index: 4,
                  imageUrl: "assets/icon/icon_profile.png",
                  text: "Profil"),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<PageCubit, int>(builder: (context, currentIndex) {
      return Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: Stack(
          children: [
            buildContent(currentIndex),
            customNavBar(),
            currentIndex == 1
                ? Positioned(
                    bottom: 90,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      tooltip: 'Upload Resep',
                      onPressed: () {
                        Navigator.pushNamed(context, '/upload-resep');
                      },
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );
    });
  }
}
