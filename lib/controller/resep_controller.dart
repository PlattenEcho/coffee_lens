import 'dart:io';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/resep.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadResep({
  required BuildContext context,
  required int userId,
  required String title,
  required String category,
  required String description,
  required String duration,
  required String imageUrl,
  required List<String> tools,
  required List<Ingredient> ingredients,
  required List<String> steps,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    ),
  );
  String? imgUrl;
  try {
    final file = File(imageUrl);
    final fileName = "${DateTime.now().toIso8601String()}.jpg";
    final response =
        await supabase.storage.from('resep_img').upload(fileName, file);
    imgUrl = supabase.storage.from('resep_img').getPublicUrl(fileName);
  } on PostgrestException catch (error) {
    showToast(context, error.message);
    return;
  } catch (_) {
    showToast(context, _.toString());
    print(_.toString());
    showToast(context, 'Failed to send message');
  }

  try {
    final resepResponse = await supabase
        .from('resep')
        .insert({
          'id_user': userId,
          'title': title,
          'category': category,
          'description': description,
          'created_at': DateTime.now().toIso8601String(),
          'waktu': int.parse(duration),
          'img_url': imgUrl,
        })
        .select()
        .single();
    final resepId = resepResponse['id'];

    final ingredientData = ingredients
        .map((ingredient) => {
              'id_resep': resepId,
              'name': ingredient.name,
              'kuantitas': ingredient.quantity,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();

    await supabase.from('bahan').insert(ingredientData);

    final stepData = steps
        .asMap()
        .entries
        .map((entry) => {
              'id_resep': resepId,
              'nomor_langkah': entry.key + 1,
              'langkah': entry.value,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('langkah').insert(stepData);

    final toolData = tools
        .map((tool) => {
              'id_resep': resepId,
              'name': tool,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('alat').insert(toolData);
    Navigator.pop(context);
    final user = storageController.getData("user");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DetailResep(
                idResep: resepId,
                rating: 0,
                idUser: userId,
                imgUrl: user["img_url"])));
    showToast(context, 'Resep uploaded successfully!');
  } catch (e) {
    Navigator.pop(context);
    print(e.toString());
    showToast(context, 'Failed to insert resep: ${e.toString()}');
  }
}

Future<void> updateResep({
  required int resepId,
  required int userId,
  required String title,
  required String category,
  required String description,
  required String duration,
  required String imageUrl,
  required List<String> tools,
  required List<Ingredient> ingredients,
  required List<String> steps,
}) async {
  String? imgUrl = imageUrl;

  if (!imageUrl.startsWith('https')) {
    final file = File(imageUrl);
    final fileName = "${DateTime.now().toIso8601String()}.jpg";
    await supabase.storage.from('resep_img').upload(fileName, file);
    imgUrl = supabase.storage.from('resep_img').getPublicUrl(fileName);
  }

  await supabase.from('resep').update({
    'title': title,
    'category': category,
    'description': description,
    'waktu': int.parse(duration),
    'img_url': imgUrl,
  }).eq('id', resepId);

  await supabase.from('bahan').delete().eq('id_resep', resepId);
  final ingredientData = ingredients
      .map((ingredient) => {
            'id_resep': resepId,
            'name': ingredient.name,
            'kuantitas': ingredient.quantity,
            'created_at': DateTime.now().toIso8601String(),
          })
      .toList();
  await supabase.from('bahan').insert(ingredientData);

  await supabase.from('langkah').delete().eq('id_resep', resepId);
  final stepData = steps
      .asMap()
      .entries
      .map((entry) => {
            'id_resep': resepId,
            'nomor_langkah': entry.key + 1,
            'langkah': entry.value,
            'created_at': DateTime.now().toIso8601String(),
          })
      .toList();
  await supabase.from('langkah').insert(stepData);

  await supabase.from('alat').delete().eq('id_resep', resepId);
  final toolData = tools
      .map((tool) => {
            'id_resep': resepId,
            'name': tool,
            'created_at': DateTime.now().toIso8601String(),
          })
      .toList();
  await supabase.from('alat').insert(toolData);
}

Future<Map<String, dynamic>> fetchDetailResep(int idResep) async {
  final response = await supabase
      .from('resep')
      .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
      .eq("id", idResep)
      .single();

  return response;
}

Future<List<Resep>> fetchFavorit() async {
  int userId = storageController.getData("user")['id'];

  final response = await supabase
      .from('favorit')
      .select(
          'id, id_user, resep(*, bahan(name, kuantitas), alat(name), langkah(langkah))')
      .eq('id_user', userId)
      .order('created_at', ascending: false);

  if (response.isEmpty) {
    return [];
  }

  List<Resep> reseps = (response as List).map((favoritData) {
    final resepData = favoritData['resep'];
    return Resep.fromJson(resepData);
  }).toList();

  for (var resep in reseps) {
    final ratings =
        await supabase.from('rating').select('rating').eq('id_resep', resep.id);
    double averageRating = 0.0;
    if (ratings.isNotEmpty) {
      averageRating = ratings
              .map((r) => (r['rating'] as num).toDouble())
              .reduce((a, b) => a + b) /
          ratings.length;
    }
    resep.rating = averageRating;

    final userResponse = await supabase
        .from('user')
        .select('username, img_url')
        .eq('id', resep.idUser)
        .maybeSingle();

    if (userResponse != null) {
      resep.username = userResponse['username'];
      resep.userImgUrl = userResponse['img_url'];
    }
  }

  return reseps;
}

Future<List<Resep>> fetchUserReseps(int userId) async {
  final response = await supabase
      .from('resep')
      .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
      .eq('id_user', userId);

  if (response.isEmpty) {
    return [];
  }

  List<Resep> reseps = (response as List).map((resepData) {
    return Resep.fromJson(resepData);
  }).toList();

  for (var resep in reseps) {
    final ratings =
        await supabase.from('rating').select('rating').eq('id_resep', resep.id);
    double averageRating = 0.0;
    if (ratings.isNotEmpty) {
      averageRating = ratings
              .map((r) => (r['rating'] as num).toDouble())
              .reduce((a, b) => a + b) /
          ratings.length;
    }
    resep.rating = averageRating;
  }

  return reseps;
}

Future<void> addFavorit(int idUser, int idResep) async {
  await supabase.from('favorit').insert({
    'id_resep': idResep,
    'id_user': idUser,
  });
}

Future<void> removeFavorit(int idUser, int idResep) async {
  await supabase
      .from('favorit')
      .delete()
      .eq('id_resep', idResep)
      .eq('id_user', idUser);
}

Future<void> updateRating(int idUser, int idResep, double rating) async {
  final checkRating = await supabase
      .from('rating')
      .select('*')
      .eq('id_resep', idResep)
      .eq('id_user', idUser)
      .maybeSingle();

  if (checkRating == null) {
    await supabase.from('rating').insert({
      'id_resep': idResep,
      'id_user': idUser,
      'rating': rating,
    });
  } else {
    await supabase.from('rating').update({
      'rating': rating,
    }).eq('id_resep', idResep);
  }
}
