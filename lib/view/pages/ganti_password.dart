import 'package:coffee_vision/controller/crypt_controller.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';

class GantiPassword extends StatelessWidget {
  GantiPassword({super.key});
  final TextEditingController oldPasswordController = TextEditingController();
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

  Future<void> updatePassword2(String password) async {
    final user = User.fromMap(storageController.getData("user"));
    String encryptedPassword = encryptMyData(password);
    await supabase
        .from('users')
        .update({'password': encryptedPassword}).eq('username', user.username);
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
        child: SingleChildScrollView(
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
                "Password Lama",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
              ),
              gapH4,
              PasswordTextForm(
                controller: oldPasswordController,
                hintText: "Masukkan password lama",
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
                text: "Ganti Password",
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  );
                  final oldPassword = oldPasswordController.text.trim();
                  final password = newPasswordController.text.trim();
                  if (!validateForm()) {
                    showToast(context, "Masih ada kolom yang kurang tepat");
                  } else {
                    try {
                      final user =
                          User.fromMap(storageController.getData("user"));
                      final response = await supabase
                          .from('users')
                          .select('password')
                          .eq('username', user.username)
                          .single();
                      if (decryptMyData(response['password']) == oldPassword) {
                        updatePassword2(password);
                        Navigator.pop(context);
                        showToast(context, "Password berhasil diubah");
                      } else {
                        showToast(context, "Passwprd lama salah");
                      }
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
