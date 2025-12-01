import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/string_utils.dart';
import 'app_text.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.accent(context),
          ),
          const SizedBox(height: 12),
          AppText(
            StringUtils.t('loading'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
