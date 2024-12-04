import 'package:coffee_vision/controller/crypt_controller.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:flutter/material.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> updatePassword(String password) async {
    final email = storageController.getData("otpData")['email'];
    String encryptedPassword = encryptMyData(password);
    await supabase
        .from('users')
        .update({'password': encryptedPassword}).eq('email', email);
    storageController.removeData("otpData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kTextColor),
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "Ubah Password",
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
                "Masukkan Password Baru",
                style: boldTextStyle.copyWith(fontSize: 28),
              ),
              gapH(8),
              Text(
                "Silakan masukkan password baru Anda dan konfirmasi untuk memastikan.",
                style: whiteTextStyle.copyWith(
                  color: kGreyColor,
                  fontWeight: light,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
              gapH12,
              Text(
                "Password Baru",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
              ),
              gapH4,
              PasswordTextForm(
                controller: newPasswordController,
                hintText: "Masukkan password baru",
                maxLines: 1,
                maxLength: 16,
                function: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 8) {
                    return 'Password harus minimal 8 karakter';
                  }
                  return null;
                },
              ),
              gapH8,
              Text(
                "Konfirmasi Password",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
              ),
              gapH4,
              PasswordTextForm(
                controller: confirmPasswordController,
                hintText: "Masukkan kembali password",
                maxLines: 1,
                maxLength: 16,
                function: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value.length < 8) {
                    return 'Password harus minimal 8 karakter';
                  }
                  if (value != newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              gapH24,
              Button(
                bgColor: kPrimaryColor,
                color: kWhiteColor,
                text: "Simpan Password",
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  );
                  final password = newPasswordController.text.trim();
                  if (!validateForm()) {
                    showToast(context, "Masih ada kolom yang kurang tepat");
                  } else {
                    try {
                      updatePassword(password);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/auth', (Route<dynamic> route) => false);
                      showToast(context,
                          "Password berhasil diubah, silahkan login dengan password baru");
                    } catch (e) {
                      showToast(context, "Error: ${{e.toString()}} ");
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
