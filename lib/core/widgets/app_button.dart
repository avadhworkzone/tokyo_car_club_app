import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool enabled; // ✅ NEW

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.enabled = true, // ✅ DEFAULT TRUE
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = enabled && !isLoading;

    final child = isLoading
        ? const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    )
        : AppText(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: isOutlined
            ? AppColors.primary
            : Colors.white,
      ),
    );

    // OUTLINED BUTTON
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isButtonEnabled ? AppColors.primary : Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
        child: child,
      );
    }

    // FILLED BUTTON
    return ElevatedButton(
      onPressed: isButtonEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isButtonEnabled ? AppColors.accent : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: child,
    );
  }
}
