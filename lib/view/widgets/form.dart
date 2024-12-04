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

class PasswordTextForm extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final String? Function(String?)? function;

  const PasswordTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.maxLength,
    required this.function,
  });

  @override
  _PasswordTextFormState createState() => _PasswordTextFormState();
}

class _PasswordTextFormState extends State<PasswordTextForm> {
  bool obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      validator: widget.function,
      obscureText: obscureText,
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
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: kGreyColor,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}

class UsernameTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final int maxLength;
  final String? Function(String?)? function;
  const UsernameTextForm({
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
      onChanged: (value) {
        controller.value = controller.value.copyWith(
          text: value.toLowerCase(),
          selection: TextSelection.collapsed(offset: value.length),
        );
      },
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
