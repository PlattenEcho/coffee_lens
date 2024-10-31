import 'package:coffee_vision/controller/crypt_controller.dart';
import 'package:coffee_vision/controller/cubit.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<bool> checkUsernameExists(String username) async {
  final response = await supabase
      .from('users')
      .select('username')
      .eq('username', username)
      .limit(1);

  return response.isNotEmpty;
}

Future<bool> checkEmailExists(String email) async {
  final response =
      await supabase.from('users').select('email').eq('email', email).limit(1);

  return response.isNotEmpty;
}

Future<void> createUser(BuildContext context, String email, String username,
    String password, String confirmPassword) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    ),
  );

  try {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Navigator.pop(context);
      return showToast(context, "Isi kolom yang kosong");
    }

    final usernameExists = await checkUsernameExists(username);
    final emailExists = await checkEmailExists(email);

    if (usernameExists) {
      Navigator.pop(context);
      return showToast(context, "Username yang anda masukkan sudah dipakai");
    }

    if (emailExists) {
      Navigator.pop(context);
      return showToast(context, "Email yang anda masukkan sudah dipakai");
    }

    if (password != confirmPassword) {
      Navigator.pop(context);
      return showToast(context, "Password dan konfirmasi password berbeda");
    }

    String encryptedPassword = encryptMyData(password);
    await supabase.from('users').insert({
      'username': username,
      'email': email,
      'password': encryptedPassword,
    });

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login-page');
    showToast(context, "Akun sudah dibuat, silahkan login");
  } catch (e) {
    Navigator.pop(context);
    showToast(context, "Error: ${e.toString()}");
    print(e.toString());
  }
}

Future<void> authenticateUser(
    BuildContext context, String username, String password) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(
        color: kPrimaryColor,
      ),
    ),
  );

  try {
    final response = await supabase
        .from('users')
        .select('id, username, email, password, created_at')
        .eq('username', username)
        .limit(1)
        .single();

    if (response.isNotEmpty) {
      final String encryptedPassword = response['password'];
      final String decryptedPassword = decryptMyData(encryptedPassword);

      if (decryptedPassword == password) {
        StorageController storageController = Get.find<StorageController>();
        storageController.saveData('isLoggedIn', true);
        final localUser = User.fromMap(response);
        storageController.saveData('user', localUser.toMap());
        Navigator.pop(context);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/main-page',
          (Route<dynamic> route) => false,
        );
        showToast(context, "Login berhasil, selamat datang $username");
      } else {
        Navigator.pop(context);
        showToast(
            context, "Login gagal, silahkan cek ulang username atau password");
      }
    } else {
      Navigator.pop(context);
      showToast(
          context, "Login gagal, silahkan cek ulang username atau password");
    }
  } catch (e) {
    Navigator.pop(context);
    showToast(context, "Terjadi kesalahan: ${e.toString()}");
    print(e.toString());
  }
}

Future<void> logout(BuildContext context) async {
  StorageController storageController = Get.find<StorageController>();
  storageController.removeData('isLoggedIn');
  storageController.removeData('user');
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/auth',
    (Route<dynamic> route) => false,
  );
  context.read<PageCubit>().setPage(1);

  showToast(context, "Anda telah berhasil logout");
}
