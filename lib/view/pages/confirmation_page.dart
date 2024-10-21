import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final File imageFile;

  const ConfirmationPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(imageFile),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lakukan sesuatu dengan gambar, misalnya menyimpan atau mengunggah
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
