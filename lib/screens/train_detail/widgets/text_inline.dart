import 'package:flutter/material.dart';
import 'package:train/core/styles/style.dart';

class TextInline extends StatelessWidget {
  const TextInline(
      {super.key, required this.title, required this.subtitle, this.large});

  final String title, subtitle;
  final bool? large;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: title,
        style: Style.body14.copyWith(
            fontSize: large == null || large == false ? 14 : 20,
            fontWeight: FontWeight.w500),
        children: [
          TextSpan(
            text: subtitle,
            style: Style.body14.copyWith(
                fontSize: large == null || large == false ? 14 : 20,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
