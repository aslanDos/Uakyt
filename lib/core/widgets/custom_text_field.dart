import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.icon,
  });

  final TextEditingController controller;
  final String? hintText;
  final HeroIcons? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: context.t.bodyMedium,
      cursorColor: context.c.onSurface,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.t.bodyMedium?.copyWith(color: context.c.outline),
        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: context.c.surface,
      ),
    );
  }
}
