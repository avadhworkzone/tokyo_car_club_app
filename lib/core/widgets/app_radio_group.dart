import 'package:flutter/material.dart';
import 'app_text.dart';

class AppRadioOption<T> {
  final T value;
  final String label;

  AppRadioOption({required this.value, required this.label});
}

class AppRadioGroup<T> extends StatelessWidget {
  final String? title;
  final T selected;
  final List<AppRadioOption<T>> options;
  final ValueChanged<T> onChanged;

  const AppRadioGroup({
    super.key,
    this.title,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          AppText(
            title!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 12,
          children: options.map((opt) {
            final isSelected = opt.value == selected;
            return ChoiceChip(
              label: AppText(
                opt.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : null,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onChanged(opt.value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
