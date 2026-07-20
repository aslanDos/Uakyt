import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/pressable.dart';

class ActionButton extends StatelessWidget {
  final HeroIcons icon;
  final VoidCallback? onTap;
  const ActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: .circle,
          border: Border.all(color: context.c.onSurface),
        ),
        child: HeroIcon(icon, size: 24, style: .solid),
      ),
    );
  }
}
