import 'package:camera/camera.dart';
import 'package:coffee_vision/controller/cubit.dart';
import 'package:coffee_vision/view/pages/auth_page.dart';
import 'package:coffee_vision/view/pages/login_page.dart';
import 'package:coffee_vision/view/pages/main_page.dart';
import 'package:coffee_vision/view/pages/onboarding.dart';
import 'package:coffee_vision/view/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<CameraDescription> cameras;

void main() async {
  ;

  runApp(const MyApp());
}

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
        '/': (context) => const MainPage(),
        '/auth': (context) => const AuthPage(),
        '/login-page': (context) => const LoginPage(),
        '/register-page': (context) => const RegisterPage(),
        '/main-page': (context) => const MainPage(),
      }),
    );
  }
}
