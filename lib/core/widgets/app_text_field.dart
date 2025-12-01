import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;

  // ⭐ NEW
  final Color? textColor;
  final Color? hintColor;

  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,

    // ⭐ NEW FIELDS
    this.textColor,
    this.hintColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: isPassword,
      onTap: onTap,
      onChanged: onChanged,

      style: TextStyle(
        color: textColor ?? AppColors.textPrimary(context),
      ),

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor ?? AppColors.textTertiary(context),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.cardBackground(context).withOpacity(0.3),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textTertiary(context)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.textTertiary(context)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.accent(context)),
        ),
      ),
    );
  }
}
