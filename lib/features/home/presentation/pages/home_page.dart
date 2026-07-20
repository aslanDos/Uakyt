import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/app/router/routes.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/action_button.dart';
import 'package:uakyt/core/widgets/completed_task_card.dart';
import 'package:uakyt/core/widgets/pressable.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/presentation/providers/task_sessions_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final sessions = ref.watch(taskSessionsProvider);
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
          child: Column(
            children: [
              tasks.when(
                data: (tasks) => sessions.when(
                  data: (sessions) {
                    final currentSession = sessions.currentSession;

                    if (currentSession == null) {
                      return const SizedBox.shrink();
                    }

                    final task = _findTask(tasks, currentSession.taskId);

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Task',
                              style: context.t.headlineLarge,
                            ),
                            ActionButton(
                              icon: HeroIcons.cog8Tooth,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _CurrentSessionCard(
                          session: currentSession,
                          task: task,
                          now: now,
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                  error: (error, _) => _ErrorCard(message: error.toString()),
                  loading: () => const _LoadingCard(),
                ),
                error: (error, _) => _ErrorCard(message: error.toString()),
                loading: () => const _LoadingCard(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today', style: context.t.headlineLarge),
                  Pressable(
                    onTap: () => context.push(AppRoutes.allTasks),
                    child: Text(
                      'See All',
                      style: context.t.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: tasks.when(
                  data: (tasks) => sessions.when(
                    data: (sessions) {
                      final completedTasks = _groupSessionsByTask(
                        sessions.completedSessions,
                      );

                      if (completedTasks.isEmpty) {
                        return Center(
                          child: Text(
                            'No completed sessions yet',
                            style: context.t.bodyMedium?.copyWith(
                              color: context.c.onSurfaceVariant,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: completedTasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final completedTask = completedTasks[index];
                          final task = _findTask(tasks, completedTask.taskId);

                          return CompletedTaskCard(
                            taskId: completedTask.taskId,
                            duration: completedTask.duration,
                            task: task,
                          );
                        },
                      );
                    },
                    error: (error, _) => Center(child: Text(error.toString())),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Center(child: Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TaskEntity? _findTask(List<TaskEntity> tasks, String id) {
    for (final task in tasks) {
      if (task.id == id) {
        return task;
      }
    }

    return null;
  }

  List<_CompletedTask> _groupSessionsByTask(List<TaskSessionEntity> sessions) {
    final durationsByTask = <String, Duration>{};

    for (final session in sessions) {
      durationsByTask.update(
        session.taskId,
        (duration) => duration + session.duration(),
        ifAbsent: session.duration,
      );
    }

    return durationsByTask.entries
        .map(
          (entry) => _CompletedTask(taskId: entry.key, duration: entry.value),
        )
        .toList();
  }
}

class _CompletedTask {
  const _CompletedTask({required this.taskId, required this.duration});

  final String taskId;
  final Duration duration;
}

class _CurrentSessionCard extends StatelessWidget {
  const _CurrentSessionCard({
    required this.session,
    required this.task,
    required this.now,
  });

  final TaskSessionEntity session;
  final TaskEntity? task;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {
        context.push(AppRoutes.taskPath(session.taskId));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Color(
            task?.colorValue ?? context.c.primary.toARGB32(),
          ).withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(session.duration(now: now)),
                  style: context.t.displayMedium?.copyWith(
                    color: context.c.onPrimary,
                  ),
                ),
                HeroIcon(
                  HeroIcons.chevronRight,
                  size: 24,
                  color: context.c.onPrimary,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                CustomPaint(
                  size: const Size(12, 12),
                  painter: RingPainter(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  task?.name ?? 'Active session',
                  style: context.t.bodyLarge?.copyWith(
                    color: context.c.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 112,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: TextStyle(color: context.c.onErrorContainer)),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFF7012CE)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawOval(rect.deflate(strokeWidth / 2), paint);
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  String twoDigits(int value) => value.toString().padLeft(2, '0');

  return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
}
