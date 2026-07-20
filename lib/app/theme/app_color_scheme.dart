import 'package:flutter/material.dart';
import 'package:uakyt/app/theme/app_colors.dart';

class AppColorScheme {
  static final ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.purple,
    onPrimary: AppColors.white,

    secondary: AppColors.lightGrey,
    onSecondary: AppColors.black,

    tertiary: AppColors.gray2,

    outline: AppColors.gray3,

    error: AppColors.pink,
    onError: AppColors.white,

    surface: AppColors.lightWhite,
    onSurface: AppColors.black,

    surfaceContainer: AppColors.white,
  );

  static final ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    primary: AppColors.purple,
    onPrimary: AppColors.white,

    secondary: AppColors.lightPurple,
    onSecondary: AppColors.white,

    tertiary: AppColors.gray4,

    outline: AppColors.gray3,

    error: AppColors.pink,
    onError: AppColors.white,

    surface: AppColors.black,
    onSurface: AppColors.white,

    surfaceContainer: AppColors.black2,
  );
}
