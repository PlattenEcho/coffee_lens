import 'package:coffee_vision/controller/authentication_controller.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTextColor),
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "Register",
          style: extraBoldTextStyle.copyWith(),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH12,
              Text("Masuk untuk Melanjutkan",
                  style: boldTextStyle.copyWith(fontSize: 28)),
              gapH(8),
              Text(
                "Masuk menggunakan username atau buat akun",
                style: whiteTextStyle.copyWith(
                  color: kGreyColor,
                  fontWeight: light,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              gapH12,
              Text(
                "Username",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              TextForm(
                  controller: usernameController,
                  hintText: "Masukkan username anda",
                  maxLines: 1,
                  maxLength: 15,
                  function: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  }),
              gapH8,
              Text(
                "Email",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              TextForm(
                  controller: emailController,
                  hintText: "Masukkan email anda",
                  maxLines: 1,
                  maxLength: 50,
                  function: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  }),
              gapH8,
              Text(
                "Password",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              PasswordTextForm(
                  controller: passwordController,
                  hintText: "Masukkan password anda",
                  maxLines: 1,
                  maxLength: 16,
                  function: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  }),
              gapH8,
              Text(
                "Konfirmasi Password",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              PasswordTextForm(
                  controller: confirmPasswordController,
                  hintText: "Masukkan ulang password anda",
                  maxLines: 1,
                  maxLength: 16,
                  function: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi Password tidak boleh kosong';
                    }
                    return null;
                  }),
              gapH24,
              Button(
                bgColor: kPrimaryColor,
                color: kWhiteColor,
                text: "Daftar",
                onPressed: () async {
                  if (!validateForm()) {
                    showToast(context, "Masih ada kesalahan pada text field");
                  } else {
                    if (passwordController.text.trim().length >= 8) {
                      await createUser(
                          context,
                          emailController.text.trim(),
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                          confirmPasswordController.text.trim());
                    } else {
                      showToast(
                          context, "Password minimal berpanjang 8 karakter");
                    }
                  }
                },
              ),
              gapH8,
              Center(
                child: RichText(
                    text: TextSpan(
                        style: mediumTextStyle.copyWith(),
                        children: <TextSpan>[
                      const TextSpan(text: "Sudah punya akun? "),
                      TextSpan(
                          text: "Masuk di sini",
                          style: blackTextStyle.copyWith(color: kPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                  context, '/login-page');
                            })
                    ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
