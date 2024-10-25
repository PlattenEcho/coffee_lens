import 'package:camera/camera.dart';
import 'package:coffee_vision/view/shared/gaps.dart';
import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'confirmation_page.dart'; // Ganti dengan path dari halaman konfirmasi

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? cameraController;
  late List<CameraDescription> cameras;
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );

    await cameraController?.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

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
              "Coba Brew Lens AI!",
              style: blackTextStyle.copyWith(fontSize: 24),
            ),
            Text(
              "Deteksi jenis kopi dengan AI",
              style: mediumTextStyle.copyWith(fontSize: 14),
            ),
            gapH64,
            Center(
              child: cameraController == null ||
                      !cameraController!.value.isInitialized
                  ? Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                          color: kBlackColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kPrimaryLight2Color)),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                          backgroundColor: kPrimaryLightColor,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: kPrimaryLight2Color, width: 4),
                        ),
                        child: CameraPreview(cameraController!),
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
                    Icons.arrow_back,
                    color: kPrimaryColor,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    if (cameraController != null &&
                        cameraController!.value.isInitialized) {
                      final image = await cameraController!.takePicture();
                      setState(() {
                        imageFile = image;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmationPage(
                            imageFile: imageFile!,
                          ),
                        ),
                      );
                    }
                  },
                  elevation: 1.0,
                  fillColor: kPrimaryColor,
                  padding: EdgeInsets.all(25.0),
                  shape: CircleBorder(),
                  child: Image.asset(
                    "assets/icon/icon_camera.png",
                    width: 36,
                    height: 36,
                    color: kWhiteColor,
                  ),
                ),
                // Tombol gallery
                RawMaterialButton(
                  onPressed: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        imageFile = pickedFile;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmationPage(imageFile: imageFile!),
                        ),
                      );
                    }
                  },
                  elevation: 1.0,
                  fillColor: kWhiteColor,
                  padding: EdgeInsets.all(20.0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.image,
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
}
