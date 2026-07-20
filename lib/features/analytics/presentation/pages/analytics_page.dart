import 'package:flutter/material.dart';
import 'package:uakyt/core/extensions/theme_x.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              // Header
              Text('My Productivity', style: context.t.headlineLarge),
            ],
          ),
        ),
      ),
    );
  }
}
