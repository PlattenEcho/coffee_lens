import 'dart:math';

import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestReset extends StatelessWidget {
  RequestReset({super.key});
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  String generateOtp() {
    final random = Random();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  Future<void> sendOtpEmail(String name, String email) async {
    const serviceId = 'service_ahbkxr3';
    const templateId = 'template_netnhzi';
    const publicKey = '2hft_x0xy_splaub9';
    final random = Random();

    final otp = (random.nextInt(900000) + 100000).toString();
    final otpExpiryTime =
        DateTime.now().add(Duration(minutes: 6)).toIso8601String();
    storageController.saveData("otpData", {
      'email': email,
      'otp': otp,
      'expiry': otpExpiryTime,
    });
    final Uri url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': publicKey,
        'template_params': {
          'name': name,
          'otp': otp,
          'email': email,
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: kTextColor),
          backgroundColor: kPrimaryLightColor,
          title: Text(
            "Lupa Password",
            style: blackTextStyle.copyWith(fontWeight: bold),
          ),
        ),
        body: Form(
          key: formKey,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH12,
                    Text("Lupa Password",
                        style: boldTextStyle.copyWith(fontSize: 28)),
                    gapH(8),
                    Text(
                      "Masukkan email akun untuk merubah password",
                      style: whiteTextStyle.copyWith(
                        color: kGreyColor,
                        fontWeight: light,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    gapH12,
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
                    gapH24,
                    Button(
                      bgColor: kPrimaryColor,
                      color: kWhiteColor,
                      text: "Request Ubah Kata Sandi",
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child:
                                CircularProgressIndicator(color: kPrimaryColor),
                          ),
                        );
                        if (!validateForm()) {
                          showToast(
                              context, "Masih ada kolom yang kurang tepat");
                        } else {
                          final data = storageController.getData("otpData");
                          try {
                            if (data == null ||
                                DateTime.now()
                                    .isAfter(DateTime.parse(data['expiry']))) {
                              final email = emailController.text.trim();
                              final response = await supabase
                                  .from('user')
                                  .select('username')
                                  .eq('email', email)
                                  .limit(1)
                                  .maybeSingle();
                              if (response != null) {
                                sendOtpEmail(response['username'], email);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/reset-kode');
                                showToast(context,
                                    "Kode OTP berhasil dikirim via Email, silahkan dicek");
                              } else {
                                Navigator.pop(context);
                                showToast(context, "Email tidak terdaftar");
                              }
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  "Kode OTP sudah dikirimkan, tunggu 6 menit untuk kode baru");
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            print('Error: ${e.toString()}');
                            showToast(
                                context, "Terjadi kesalahan, coba lagi nanti");
                          }
                        }
                      },
                    ),
                  ])),
        ));
  }
}
