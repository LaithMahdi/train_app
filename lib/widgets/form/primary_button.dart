import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.name,
    required this.onPressed,
    this.disabled,
    this.loading,
  });

  final String name;
  final VoidCallback onPressed;
  final bool? disabled;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled == null || disabled == false ? 1 : .5,
      child: IgnorePointer(
        ignoring: disabled == null || disabled == false ? false : true,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.secondaryColor,
            shadowColor: AppColor.secondaryColor,
            elevation: 10,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading == null || loading == false
              ? Text(
                  name,
                  style: Style.body14.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: AppColor.primaryColor, strokeWidth: 3),
                  ),
                ),
        ),
      ),
    );
  }
}
