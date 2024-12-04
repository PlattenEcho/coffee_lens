import 'dart:io';

import 'package:coffee_vision/controller/user_controller.dart';
import 'package:coffee_vision/main.dart';
import 'package:coffee_vision/model/user.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:coffee_vision/view/widgets/form.dart';
import 'package:coffee_vision/view/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfil extends StatefulWidget {
  final User user;
  const EditProfil({super.key, required this.user});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  File? image;
  bool isUsernameAvailable = true;
  @override
  void initState() {
    super.initState();

    usernameController.text = widget.user.username;
    descriptionController.text = widget.user.description;
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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkUsername() async {
    final newUsername = usernameController.text.trim();
    if (newUsername.isEmpty || newUsername == widget.user.username) return;

    final response =
        await supabase.from("users").select("*").eq("username", newUsername);

    setState(() {
      isUsernameAvailable = response.isEmpty;
    });
  }

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: blackTextStyle,
        ),
        backgroundColor: kPrimaryLightColor,
        actions: [
          InkWell(
            onTap: () {
              if (!validateForm()) {
                showToast(context, "Masih ada kolom yang kosong!");
                return;
              } else {
                updateProfile(
                    context: context,
                    newUsername: usernameController.text.trim(),
                    newDescription: descriptionController.text.trim(),
                    imagePath: image?.path);
              }
            },
            child: Row(
              children: [
                Icon(Icons.check),
                gapW4,
                Text(
                  "Simpan",
                  style: boldTextStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                gapW12
              ],
            ),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                          radius: 60,
                          onBackgroundImageError: (error, stackTrace) {},
                          backgroundImage: image == null
                              ? widget.user.imgUrl.isNotEmpty
                                  ? NetworkImage(widget.user.imgUrl)
                                  : AssetImage("assets/pfp_placeholder.jpg")
                              : FileImage(image!) as ImageProvider),
                    ),
                    gapH8,
                    Text(
                      "Klik untuk ubah foto profil",
                      style: boldTextStyle.copyWith(fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              gapH24,
              Text(
                "Username",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              UsernameTextForm(
                  function: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    } else if (!isUsernameAvailable) {
                      return 'Username sudah digunakan';
                    }
                    return null;
                  },
                  controller: usernameController,
                  maxLines: 1,
                  maxLength: 20,
                  hintText: "Isi username disini"),
              gapH8,
              Text(
                "Deskripsi",
                style: semiBoldTextStyle.copyWith(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              gapH4,
              TextForm(
                  function: (value) {},
                  controller: descriptionController,
                  maxLines: 2,
                  maxLength: 200,
                  hintText: "Isi deskripsi disini"),
              gapH12,
            ],
          ),
        ),
      ),
    );
  }
}
