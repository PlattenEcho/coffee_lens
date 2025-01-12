import 'package:coffee_vision/controller/cubit.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/arabica_page.dart';
import 'package:coffee_vision/view/pages/auth_page.dart';
import 'package:coffee_vision/view/pages/camera_page.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/pages/edit_profil.dart';
import 'package:coffee_vision/view/pages/favorit_page.dart';
import 'package:coffee_vision/view/pages/followers_list.dart';
import 'package:coffee_vision/view/pages/ganti_password.dart';
import 'package:coffee_vision/view/pages/login_page.dart';
import 'package:coffee_vision/view/pages/main_page.dart';
import 'package:coffee_vision/view/pages/onboarding.dart';
import 'package:coffee_vision/view/pages/other_profile.dart';
import 'package:coffee_vision/view/pages/profile_page.dart';
import 'package:coffee_vision/view/pages/register_page.dart';
import 'package:coffee_vision/view/pages/request_reset.dart';
import 'package:coffee_vision/view/pages/resep_page.dart';
import 'package:coffee_vision/view/pages/reset_kode.dart';
import 'package:coffee_vision/view/pages/reset_password.dart';
import 'package:coffee_vision/view/pages/robusta_page.dart';
import 'package:coffee_vision/view/pages/setting_page.dart';
import 'package:coffee_vision/view/pages/splash_screen.dart';
import 'package:coffee_vision/view/pages/upload_resep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coffee_vision/model/user.dart' as Pengguna;

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ohhqztwfnukcmlybgrqn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oaHF6dHdmbnVrY21seWJncnFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk2OTQxODAsImV4cCI6MjA0NTI3MDE4MH0.864yqF1-0r1a1pX23z6D32cwN_bliSn8WpEBcSu5MC0',
  );
  await GetStorage.init();
  Get.put(StorageController());
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageCubit(),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingPage(),
        '/auth': (context) => const AuthPage(),
        '/login-page': (context) => const LoginPage(),
        '/register-page': (context) => const RegisterPage(),
        '/main-page': (context) => const MainPage(),
        '/camera-page': (context) => CameraPage(),
        '/setting-page': (context) => SettingPage(),
        '/upload-resep': (context) => const UploadResep(),
        '/detail-resep': (context) =>
            DetailResep(idResep: 1, rating: 0.0, idUser: 1, imgUrl: ""),
        '/robusta-page': (context) => const RobustaPage(),
        '/arabica-page': (context) => const ArabicaPage(),
        '/edit-profil': (context) => EditProfil(
              user: sampleUser,
            ),
        '/followers-list': (context) => FollowersList(idUser: 1),
        '/request-reset': (context) => RequestReset(),
        '/reset-kode': (context) => ResetKode(),
        '/reset-password': (context) => ResetPassword(),
        '/ganti-password': (context) => GantiPassword(),
        '/profile-page': (context) => ProfilePage(),
        '/other-profile': (context) => OtherProfile(idUser: 1),
        '/resep-page': (context) => ResepPage(),
        '/favorit-page': (context) => FavoritPage()
      }),
    );
  }
}

final sampleUser = Pengguna.User(
    id: 0,
    username: "username",
    email: "email",
    description: "description",
    createdAt: DateTime.now(),
    imgUrl:
        "https://ohhqztwfnukcmlybgrqn.supabase.co/storage/v1/object/public/profile_pic/pfp_placeholder.jpg?t=2024-11-01T19%3A27%3A09.465Z");

final sampleResep = Resep(
    id: 0,
    idUser: 0,
    title: "Iced Coffee Latte",
    category: "Beverage",
    description:
        "A refreshing iced coffee latte with a creamy and smooth texture.",
    duration: "10 mins",
    rating: 4.5,
    imageUrl: "assets/onboarding1.jpg",
    tools: ["Blender", "Measuring Cup", "Glass"],
    ingredients: [
      Ingredient(name: "Coffee", quantity: "2 tablespoons"),
      Ingredient(name: "Milk", quantity: "1 cup"),
      Ingredient(name: "Ice Cubes", quantity: "1 cup"),
      Ingredient(name: "Sugar", quantity: "1 teaspoon"),
    ],
    steps: [
      "Brew the coffee and let it cool.",
      "Add milk, coffee, ice, and sugar to the blender.",
      "Blend until smooth.",
      "Pour into a glass and enjoy your iced coffee latte!",
    ],
    createdAt: DateTime.now());
