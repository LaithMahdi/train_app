import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/constants/app_image.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        AppImage.logo,
        width: 40,
        height: 40,
        color: AppColor.primaryColor,
      ),
    );
  }
}
