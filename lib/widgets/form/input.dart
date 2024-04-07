import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.hintText,
    this.suffixIcon,
    required this.controller,
    this.obscure,
    this.validator,
    this.readOnly,
    this.keyboardType,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final bool? obscure;
  final Widget? suffixIcon;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly == null || readOnly == false ? false : true,
      controller: controller,
      validator: validator,
      obscureText: obscure == null || obscure == false ? false : true,
      keyboardType: keyboardType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Style.body14.copyWith(color: AppColor.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        hintStyle: Style.body14.copyWith(color: AppColor.greyAccentDark),
        filled: true,
        fillColor: AppColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
        errorStyle: Style.body12.copyWith(color: AppColor.errorColor),
      ),
    );
  }
}
