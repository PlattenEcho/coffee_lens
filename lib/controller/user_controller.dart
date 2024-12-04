import 'dart:io';

import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';

Future<void> updateProfile(
    {required BuildContext context,
    required String newUsername,
    required String newDescription,
    String? imagePath}) async {
  final user = storageController.getData('user');
  String? imgUrl;

  if (imagePath != null) {
    final file = File(imagePath!);
    final fileName =
        "${user['id']}_${user['username']}_${DateTime.now().toIso8601String()}.jpg";
    try {
      final response =
          await supabase.storage.from('profile_pic').upload(fileName, file);
      imgUrl = supabase.storage.from('profile_pic').getPublicUrl(fileName);
    } catch (e) {
      showToast(context, "Image upload failed: ${e.toString()}");
    }
  }

  try {
    final updateResponse = await supabase.from("users").update({
      'username': newUsername,
      'deskripsi': newDescription,
      'img_url': imagePath != null ? imgUrl : user['img_url'],
    }).eq('id', user['id']);

    final updatedUser = User(
      id: user['id'],
      username: newUsername,
      email: user['email'],
      createdAt: DateTime.parse(user['created_at']),
      description: newDescription,
      imgUrl: imgUrl ?? user['img_url'],
    );

    storageController.saveData('user', updatedUser.toMap());

    showToast(context, "Profile updated successfully");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-page',
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    showToast(context, "Profile update failed: ${e.toString()}");
    print(e);
  }
}

Future<List<Map<String, dynamic>>> fetchFollowings(int idUser) async {
  try {
    final response = await supabase
        .from('follows')
        .select('id_following(id, username, deskripsi, img_url)')
        .eq('id_follower', idUser);

    return response as List<Map<String, dynamic>>;
  } catch (e) {
    print(e.toString());
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchFollowers(int idUser) async {
  try {
    final response = await supabase
        .from('follows')
        .select('id_follower(id, username, deskripsi, img_url)')
        .eq('id_following', idUser);

    return response as List<Map<String, dynamic>>;
  } catch (e) {
    print(e.toString());
    return [];
  }
}
