import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';

class Label extends StatelessWidget {
  const Label(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        label,
        style: Style.body14.copyWith(
          color: AppColor.greyLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
