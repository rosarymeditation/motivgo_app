import 'package:flutter/material.dart';

class ThemedDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const ThemedDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
    this.borderRadius = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey[600]! : Colors.grey,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        icon: Icon(
          Icons.arrow_downward,
          color: Theme.of(context).iconTheme.color,
        ),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        dropdownColor: isDark ? Colors.grey[900] : Colors.white,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        underline: const SizedBox(), // removes default underline
      ),
    );
  }
}
