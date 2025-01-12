import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';

class ResetKode extends StatelessWidget {
  ResetKode({super.key});

  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  bool isOtpValid(String inputOtp) {
    final otpData = storageController.getData('otpData');
    if (otpData == null) return false;

    final storedOtp = otpData['otp'];
    final expiryTime = DateTime.parse(otpData['expiry']);

    if (inputOtp == storedOtp && DateTime.now().isBefore(expiryTime)) {
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
          "Verifikasi Kode OTP",
          style: blackTextStyle.copyWith(fontWeight: bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH12,
              Text(
                "Masukkan Kode OTP",
                style: boldTextStyle.copyWith(fontSize: 28),
              ),
              gapH(8),
              Text(
                "Kami telah mengirimkan kode OTP ke email Anda. Silakan masukkan kode tersebut untuk melanjutkan.",
                style: whiteTextStyle.copyWith(
                  color: kGreyColor,
                  fontWeight: light,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "Kode OTP hanya berlaku selama 6 menit",
                style: boldTextStyle.copyWith(fontSize: 18),
              ),
              gapH12,
              Text(
                "Kode OTP",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
              ),
              gapH4,
              TextForm(
                controller: otpController,
                hintText: "Masukkan kode OTP",
                maxLines: 1,
                maxLength: 6,
                function: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode OTP tidak boleh kosong';
                  }
                  if (value.length != 6) {
                    return 'Kode OTP harus terdiri dari 6 angka';
                  }
                  return null;
                },
              ),
              gapH24,
              Button(
                bgColor: kPrimaryColor,
                color: kWhiteColor,
                text: "Verifikasi",
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  );
                  if (!validateForm()) {
                    showToast(context, "Masih ada kolom yang kurang tepat");
                  } else {
                    if (isOtpValid(otpController.text.trim())) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/reset-password');
                      showToast(context, "Kode OTP berhasil diverifikasi");
                    } else {
                      Navigator.pop(context);
                      showToast(context, "Kode OTP salah");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
