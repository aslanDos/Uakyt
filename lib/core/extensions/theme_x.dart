import 'package:flutter/material.dart';

extension ThemeAccessor on BuildContext {
  TextTheme get t => Theme.of(this).textTheme;
  ColorScheme get c => Theme.of(this).colorScheme;
}
