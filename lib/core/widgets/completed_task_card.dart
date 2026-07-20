import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uakyt/app/router/routes.dart';
import 'package:uakyt/core/constants/app_icons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/pressable.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';

class CompletedTaskCard extends StatelessWidget {
  const CompletedTaskCard({
    super.key,
    required this.taskId,
    required this.duration,
    required this.task,
  });

  final String taskId;
  final Duration duration;
  final TaskEntity? task;

  @override
  Widget build(BuildContext context) {
    final appIcon = AppIcon.fromName(task?.iconName ?? AppIcon.archive.name);
    final color = Color(task?.colorValue ?? context.c.primary.toARGB32());

    return Pressable(
      onTap: task == null
          ? null
          : () {
              context.push(AppRoutes.taskPath(taskId));
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.c.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(appIcon.icon, size: 24, color: context.c.onPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task?.name ?? 'Deleted task',
                    style: context.t.bodyLarge,
                  ),
                  Text(
                    _formatDuration(duration),
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurfaceVariant,
                    ),
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

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
}
