import 'package:flutter/material.dart';

final TextTheme appTextTheme = .new(
  displayLarge: AppTextStyle.display40,
  displayMedium: AppTextStyle.display32,
  displaySmall: AppTextStyle.display12,

  headlineLarge: AppTextStyle.heading24,
  headlineMedium: AppTextStyle.heading14,

  titleLarge: AppTextStyle.title16,

  bodyLarge: AppTextStyle.body16,
  bodyMedium: AppTextStyle.body14,
  bodySmall: AppTextStyle.body12,
);

class AppTextStyle {
  static const TextStyle display40 = TextStyle(
    fontSize: 40,
    fontWeight: .w600,
    height: 1.25,
  );

  static const TextStyle display32 = TextStyle(
    fontSize: 32,
    fontWeight: .w600,
    height: 1.6,
  );

  static const TextStyle display12 = TextStyle(
    fontSize: 12,
    fontWeight: .w400,
    height: 0.6,
  );

  static const TextStyle heading24 = TextStyle(
    fontSize: 24,
    fontWeight: .w600,
    height: 1,
  );

  static const TextStyle heading14 = TextStyle(
    fontSize: 14,
    fontWeight: .w600,
    height: 0.7,
  );

  static const TextStyle title16 = TextStyle(
    fontSize: 16,
    fontWeight: .w400,
    height: 0.7,
  );

  static const TextStyle body16 = TextStyle(
    fontSize: 16,
    fontWeight: .w400,
    height: 0.8,
  );

  static const TextStyle body14 = TextStyle(
    fontSize: 14,
    fontWeight: .w400,
    height: 0.7,
  );

  static const TextStyle body12 = TextStyle(
    fontSize: 12,
    fontWeight: .w400,
    height: 0.8,
  );
}
