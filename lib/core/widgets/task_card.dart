import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/app/router/routes.dart';
import 'package:uakyt/core/constants/app_icons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/pressable.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final TaskEntity task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appIcon = AppIcon.fromName(task.iconName);

    return Pressable(
      onTap: onTap ?? () => context.push(AppRoutes.taskPath(task.id)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(task.colorValue),
                shape: BoxShape.circle,
              ),
              child: Icon(appIcon.icon, size: 24, color: context.c.onPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(task.name, style: context.t.headlineMedium),
                  HeroIcon(
                    HeroIcons.play,
                    style: HeroIconStyle.solid,
                    size: 24,
                    color: context.c.outline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
