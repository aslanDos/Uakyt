import 'package:flutter/material.dart';
import 'package:uakyt/app/router/router.dart';
import 'package:uakyt/app/theme/app_theme.dart';

class UakytApp extends StatelessWidget {
  const UakytApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
