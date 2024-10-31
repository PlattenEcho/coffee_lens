import 'package:coffee_vision/view/shared/theme.dart';
import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final String? Function(String?)? function;
  const TextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.maxLength,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: function,
      decoration: InputDecoration(
          filled: true,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kGreyColor.withOpacity(0.5)),
          ),
          fillColor: kWhiteColor,
          hintStyle: regularTextStyle.copyWith(
            color: kGreyColor,
          ),
          hintText: hintText),
    );
  }
}
