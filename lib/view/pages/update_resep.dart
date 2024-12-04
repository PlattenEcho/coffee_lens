import 'dart:io';

import 'package:coffee_vision/controller/resep_controller.dart';
import 'package:coffee_vision/controller/storage_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/recipe.dart';
import 'package:coffee_vision/view/pages/detail_resep.dart';
import 'package:coffee_vision/view/pages/preview_resep.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/button.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UpdateResep extends StatefulWidget {
  final int idResep;
  const UpdateResep({super.key, required this.idResep});

  @override
  State<UpdateResep> createState() => _UpdateResepState();
}

class _UpdateResepState extends State<UpdateResep> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> stepControllers = [TextEditingController()];

  bool isLoading = true;
  Recipe? recipe;
  String selectedCategory = "Espresso";
  File? image;
  String imgUrl = "";

  List<TextEditingController> tools = [TextEditingController()];

  List<Map<String, TextEditingController>> ingredients = [
    {"name": TextEditingController(), "quantity": TextEditingController()}
  ];

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    final response = await supabase
        .from('resep')
        .select('*, bahan(name, kuantitas), alat(name), langkah(langkah)')
        .eq("id", widget.idResep)
        .single();
    try {
      setState(() {
        recipe = Recipe.fromJson(response);
        titleController.text = recipe!.title;
        selectedCategory = recipe!.category;
        minuteController.text = recipe!.duration;
        descriptionController.text = recipe!.description;
        imgUrl = recipe!.imageUrl;
        tools = recipe!.tools.map((tool) {
          return TextEditingController(text: tool);
        }).toList();

        ingredients = recipe!.ingredients.map((ingredient) {
          return {
            "name": TextEditingController(text: ingredient.name),
            "quantity": TextEditingController(text: ingredient.quantity),
          };
        }).toList();

        // Initialize steps
        stepControllers = recipe!.steps.map((step) {
          return TextEditingController(text: step);
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    bool isProcessing = false;
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Sumber Gambar"),
          actions: [
            TextButton(
              child: Text("Kamera"),
              onPressed: isProcessing
                  ? null
                  : () async {
                      isProcessing = true;
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      Navigator.pop(context, image);
                    },
            ),
            TextButton(
              child: Text("Galeri"),
              onPressed: isProcessing
                  ? null
                  : () async {
                      isProcessing = true;
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      Navigator.pop(context, image);
                    },
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          title: Text(
            "Update Resep",
            style: blackTextStyle.copyWith(fontSize: 24),
          ),
          backgroundColor: kPrimaryLightColor,
          elevation: 0,
          actions: [
            InkWell(
              onTap: () {
                if (!validateForm()) {
                  showToast(context, "Masih ada kolom yang belum diisi");
                } else {
                  List<Ingredient> ingredientList =
                      ingredients.map((ingredient) {
                    return Ingredient(
                      name: ingredient["name"]!.text.trim(),
                      quantity: ingredient["quantity"]!.text.trim(),
                    );
                  }).toList();

                  List<String> stepList = stepControllers
                      .map((stepController) => stepController.text.trim())
                      .toList();

                  List<String> toolList = tools
                      .map((toolController) => toolController.text.trim())
                      .toList();

                  Recipe recipe = Recipe(
                    id: 0,
                    idUser: 0,
                    title: titleController.text.trim(),
                    category: selectedCategory.trim(),
                    duration: minuteController.text.trim(),
                    description: descriptionController.text.trim(),
                    imageUrl: image == null ? imgUrl : image?.path ?? '',
                    ingredients: ingredientList,
                    rating: 4.8,
                    steps: stepList,
                    tools: toolList,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewResep(recipe: recipe)),
                  );
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.remove_red_eye),
                  gapW4,
                  Text(
                    "Preview",
                    style: regularTextStyle.copyWith(),
                  ),
                ],
              ),
            ),
            gapW12
          ],
        ),
        body: recipe == null || isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                color: kPrimaryColor,
              ))
            : Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: pickImage,
                        child: Container(
                          width: parentW(context),
                          height: 250,
                          decoration: BoxDecoration(
                            color: kGreyColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: image == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    recipe!.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      gapH12,
                      Text(
                        "Nama Resep",
                        style: semiBoldTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      gapH4,
                      TextForm(
                          function: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama Resep tidak boleh kosong';
                            }
                            return null;
                          },
                          controller: titleController,
                          maxLines: 1,
                          maxLength: 30,
                          hintText: "Cappucino Latte.."),
                      gapH12,
                      Text(
                        "Kategori",
                        style: semiBoldTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      gapH4,
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: kWhiteColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kGreyColor.withOpacity(0.5)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                          ),
                        ),
                        items: ["Espresso", "Latte", "Cappuccino"]
                            .map(
                              (category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                      gapH12,
                      Text(
                        "Waktu Pembuatan (Menit)",
                        style: semiBoldTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      gapH4,
                      TextField(
                        controller: minuteController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "5",
                          filled: true,
                          fillColor: kWhiteColor,
                          hintStyle:
                              regularTextStyle.copyWith(color: kGreyColor),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kGreyColor.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      gapH12,
                      Text(
                        "Deskripsi",
                        style: semiBoldTextStyle.copyWith(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      gapH4,
                      TextForm(
                          controller: descriptionController,
                          maxLines: 4,
                          maxLength: 200,
                          function: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi tidak boleh kosong';
                            }
                            return null;
                          },
                          hintText: "Tulis deskripsi resep..."),
                      gapH12,
                      TabBar(
                        indicatorColor: kPrimaryColor,
                        labelColor: kPrimaryColor,
                        unselectedLabelColor: kGreyColor,
                        labelStyle: blackTextStyle.copyWith(fontSize: 16),
                        unselectedLabelStyle:
                            blackTextStyle.copyWith(fontSize: 16),
                        tabs: [
                          Tab(text: "Alat dan Bahan"),
                          Tab(text: "Langkah"),
                        ],
                      ),
                      gapH12,
                      Container(
                        height: 400,
                        padding: EdgeInsets.all(4),
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Alat",
                                    style:
                                        blackTextStyle.copyWith(fontSize: 24),
                                  ),
                                  gapH8,
                                  ...tools.map((toolController) {
                                    int index = tools.indexOf(toolController);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextForm(
                                                function: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Nama alat tidak boleh kosong';
                                                  }
                                                  return null;
                                                },
                                                maxLength: 60,
                                                controller: toolController,
                                                maxLines: 1,
                                                hintText: "Nama alat..."),
                                          ),
                                          index + 1 != 1
                                              ? IconButton(
                                                  icon: Icon(
                                                      Icons.remove_circle,
                                                      color: kPrimaryColor),
                                                  onPressed: () {
                                                    setState(() {
                                                      tools.removeAt(index);
                                                    });
                                                  },
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Button(
                                    bgColor: kPrimaryLight2Color,
                                    color: kPrimaryColor,
                                    text: "+ Tambah Alat",
                                    onPressed: () {
                                      setState(() {
                                        tools.add(TextEditingController());
                                      });
                                    },
                                  ),
                                  gapH12,
                                  Text(
                                    "Bahan",
                                    style:
                                        blackTextStyle.copyWith(fontSize: 24),
                                  ),
                                  gapH8,
                                  ...ingredients.map((ingredient) {
                                    int index = ingredients.indexOf(ingredient);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Nama bahan tidak boleh kosong';
                                                }
                                                return null;
                                              },
                                              controller: ingredient["name"],
                                              maxLength: 40,
                                              decoration: InputDecoration(
                                                filled: true,
                                                hintText: "Nama bahan",
                                                fillColor: kWhiteColor,
                                                hintStyle:
                                                    regularTextStyle.copyWith(
                                                        color: kGreyColor),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kGreyColor
                                                          .withOpacity(0.5)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          gapW8,
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Kadar tidak boleh kosong';
                                                }
                                                return null;
                                              },
                                              maxLength: 6,
                                              controller:
                                                  ingredient["quantity"],
                                              decoration: InputDecoration(
                                                filled: true,
                                                hintText: "Jumlah",
                                                fillColor: kWhiteColor,
                                                hintStyle:
                                                    regularTextStyle.copyWith(
                                                        color: kGreyColor),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kGreyColor
                                                          .withOpacity(0.5)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          index + 1 != 1
                                              ? IconButton(
                                                  icon: Icon(
                                                      Icons.remove_circle,
                                                      color: kPrimaryColor),
                                                  onPressed: () {
                                                    setState(() {
                                                      ingredients
                                                          .removeAt(index);
                                                    });
                                                  },
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Button(
                                    bgColor: kPrimaryLight2Color,
                                    color: kPrimaryColor,
                                    text: "+ Tambah Bahan",
                                    onPressed: () {
                                      setState(() {
                                        ingredients.add({
                                          "name": TextEditingController(),
                                          "quantity": TextEditingController(),
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...stepControllers.map((stepController) {
                                    int index =
                                        stepControllers.indexOf(stepController);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Step ${index + 1}",
                                                style: blackTextStyle.copyWith(
                                                    fontSize: 24),
                                              ),
                                              index + 1 != 1
                                                  ? IconButton(
                                                      icon: Icon(
                                                          Icons.remove_circle,
                                                          color: kPrimaryColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          stepControllers
                                                              .removeAt(index);
                                                        });
                                                      },
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),
                                          gapH8,
                                          TextForm(
                                              function: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Langkah tidak boleh kosong';
                                                }
                                                return null;
                                              },
                                              maxLength: 200,
                                              controller: stepController,
                                              maxLines: 4,
                                              hintText:
                                                  "Tulis penjelasan langkah"),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Button(
                                    bgColor: kPrimaryLight2Color,
                                    color: kPrimaryColor,
                                    text: "+ Tambah Langkah",
                                    onPressed: () {
                                      setState(() {
                                        stepControllers
                                            .add(TextEditingController());
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: kPrimaryLightColor,
              border: Border(top: BorderSide(color: kGreyColor))),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                bgColor: kPrimaryColor,
                color: kWhiteColor,
                text: "Update Resep",
                onPressed: () {
                  if (!validateForm()) {
                    showToast(context, "Masih ada kolom yang belum diisi");
                  } else {
                    List<Ingredient> ingredientList =
                        ingredients.map((ingredient) {
                      return Ingredient(
                        name: ingredient["name"]!.text.trim(),
                        quantity: ingredient["quantity"]!.text.trim(),
                      );
                    }).toList();

                    List<String> stepList = stepControllers
                        .map((stepController) => stepController.text.trim())
                        .toList();

                    List<String> toolList = tools
                        .map((toolController) => toolController.text.trim())
                        .toList();

                    updateRecipe(
                      context: context,
                      recipeId: widget.idResep,
                      userId: storageController.getData("user")['id'],
                      title: titleController.text.trim(),
                      category: selectedCategory.trim(),
                      duration: minuteController.text.trim(),
                      description: descriptionController.text.trim(),
                      imageUrl: image?.path ?? recipe!.imageUrl,
                      ingredients: ingredientList,
                      rating: 0,
                      steps: stepList,
                      tools: toolList,
                    );
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
