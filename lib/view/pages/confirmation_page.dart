import 'dart:io';
import 'package:camera/camera.dart';
import 'package:coffee_vision/view/pages/result_page.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ConfirmationPage extends StatefulWidget {
  final XFile imageFile;

  const ConfirmationPage({super.key, required this.imageFile});

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  File? croppedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(
          "AI Camera",
          style: blackTextStyle.copyWith(fontSize: 24),
        ),
        backgroundColor: kPrimaryLightColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Check or Crop!",
              style: blackTextStyle.copyWith(fontSize: 24),
            ),
            Text(
              "Pastikan biji kopi terlihat di hasil foto",
              style: mediumTextStyle.copyWith(fontSize: 14),
            ),
            gapH64,
            Center(
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPrimaryLight2Color),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    croppedImage ?? File(widget.imageFile.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            gapH64,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 1.0,
                  fillColor: kWhiteColor,
                  padding: EdgeInsets.all(20.0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.close,
                    color: kPrimaryColor,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          image: croppedImage ?? File(widget.imageFile.path),
                        ),
                      ),
                    );
                  },
                  elevation: 1.0,
                  fillColor: kPrimaryColor,
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.check,
                    color: kWhiteColor,
                    size: 48,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    await cropImage(File(widget.imageFile.path));
                  },
                  elevation: 1.0,
                  fillColor: kWhiteColor,
                  padding: EdgeInsets.all(20.0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.crop,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      setState(() {
        croppedImage = File(croppedFile.path);
      });
    }
  }
}
