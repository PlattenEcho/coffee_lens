import 'dart:io';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadRecipe({
  required BuildContext context,
  required int userId,
  required String title,
  required String category,
  required String description,
  required String duration,
  required double rating,
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

  // Step 2: Insert into 'resep' table
  try {
    final recipeResponse = await supabase
        .from('resep')
        .insert({
          'id_user': userId,
          'title': title,
          'category': category,
          'description': description,
          'created_at': DateTime.now().toIso8601String(),
          'waktu': int.parse(duration), // Ensure duration is an integer
          'img_url': imgUrl,
        })
        .select()
        .single();
    final recipeId = recipeResponse['id'];

    final ingredientData = ingredients
        .map((ingredient) => {
              'id_resep': recipeId,
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
              'id_resep': recipeId,
              'nomor_langkah': entry.key + 1,
              'langkah': entry.value,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('langkah').insert(stepData);

    final toolData = tools
        .map((tool) => {
              'id_resep': recipeId,
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
                idResep: recipeId,
                rating: rating,
                idUser: userId,
                username: user['username'],
                imgUrl: user["img_url"])));
    showToast(context, 'Recipe uploaded successfully!');
  } catch (e) {
    Navigator.pop(context);
    print(e.toString());
    showToast(context, 'Failed to insert recipe: ${e.toString()}');
  }
}

Future<void> updateRecipe({
  required BuildContext context,
  required int recipeId,
  required int userId,
  required String title,
  required String category,
  required String description,
  required String duration,
  required double rating,
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

  String? imgUrl = imageUrl;

  try {
    if (!imageUrl.startsWith('https')) {
      final file = File(imageUrl);
      final fileName = "${DateTime.now().toIso8601String()}.jpg";
      await supabase.storage.from('resep_img').upload(fileName, file);
      imgUrl = supabase.storage.from('resep_img').getPublicUrl(fileName);
    }

    // Update 'resep' table
    await supabase.from('resep').update({
      'title': title,
      'category': category,
      'description': description,
      'waktu': int.parse(duration),
      'img_url': imgUrl,
    }).eq('id', recipeId);

    // Update ingredients by removing old and inserting new
    await supabase.from('bahan').delete().eq('id_resep', recipeId);
    final ingredientData = ingredients
        .map((ingredient) => {
              'id_resep': recipeId,
              'name': ingredient.name,
              'kuantitas': ingredient.quantity,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('bahan').insert(ingredientData);

    // Update steps by removing old and inserting new
    await supabase.from('langkah').delete().eq('id_resep', recipeId);
    final stepData = steps
        .asMap()
        .entries
        .map((entry) => {
              'id_resep': recipeId,
              'nomor_langkah': entry.key + 1,
              'langkah': entry.value,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('langkah').insert(stepData);

    // Update tools by removing old and inserting new
    await supabase.from('alat').delete().eq('id_resep', recipeId);
    final toolData = tools
        .map((tool) => {
              'id_resep': recipeId,
              'name': tool,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('alat').insert(toolData);

    Navigator.pop(context);
    showToast(context, 'Recipe updated successfully!');
  } catch (e) {
    Navigator.pop(context);
    print(e.toString());
    showToast(context, 'Failed to update recipe: ${e.toString()}');
  }
}
