import 'dart:io';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadRecipe({
  required BuildContext context,
  required int userId,
  required Recipe recipe,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    ),
  );
  String? imageUrl;
  try {
    final file = File(recipe.imageUrl); // Convert path to a File
    final fileName = "${DateTime.now().toIso8601String()}.jpg";
    final response =
        await supabase.storage.from('resep_img').upload(fileName, file);
    imageUrl = supabase.storage.from('resep_img').getPublicUrl(fileName);
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
          'title': recipe.title,
          'category': recipe.category,
          'description': recipe.description,
          'created_at': DateTime.now().toIso8601String(),
          'waktu': int.parse(recipe.duration), // Ensure duration is an integer
          'img_url': imageUrl,
        })
        .select()
        .single();
    final recipeId = recipeResponse['id'];

    final ingredientData = recipe.ingredients
        .map((ingredient) => {
              'id_resep': recipeId,
              'name': ingredient.name,
              'kuantitas': ingredient.quantity,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();

    await supabase.from('bahan').insert(ingredientData);

    final stepData = recipe.steps
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

    final toolData = recipe.tools
        .map((tool) => {
              'id_resep': recipeId,
              'name': tool,
              'created_at': DateTime.now().toIso8601String(),
            })
        .toList();
    await supabase.from('alat').insert(toolData);
    Navigator.pop(context);
    showToast(context, 'Recipe uploaded successfully!');
  } catch (e) {
    Navigator.pop(context);
    print(e.toString());
    showToast(context, 'Failed to insert recipe: ${e.toString()}');
  }
}
