import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final EdgeInsets padding;
  final double? width;

  const Button({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.padding = const EdgeInsets.all(16.0),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: padding,
        ),
        child: Text(label),
      ),
    );
  }
}
