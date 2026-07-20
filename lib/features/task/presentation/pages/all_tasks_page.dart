import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/utils/date_utils.dart';
import 'package:uakyt/core/widgets/action_button.dart';
import 'package:uakyt/core/widgets/completed_task_card.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/presentation/providers/task_sessions_provider.dart';

class AllTasksPage extends ConsumerWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final sessions = ref.watch(taskSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: ActionButton(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: HeroIcons.chevronLeft,
          ),
        ),
        centerTitle: true,
        title: Text('All Tasks', style: context.t.headlineLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: tasks.when(
                  data: (tasks) => sessions.when(
                    data: (sessions) {
                      final sections = _groupSessionsByDay(
                        sessions.completedSessions,
                      );

                      if (sections.isEmpty) {
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
                        itemCount: sections.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 32),
                        itemBuilder: (context, index) {
                          final section = sections[index];

                          return _TaskDaySection(
                            section: section,
                            tasks: tasks,
                          );
                        },
                      );
                    },
                    error: (error, _) => _ErrorMessage(error: error),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => _ErrorMessage(error: error),
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

  List<_TaskDay> _groupSessionsByDay(List<TaskSessionEntity> sessions) {
    final durationsByDay = <DateTime, Map<String, Duration>>{};

    for (final session in sessions) {
      final endedAt = session.endedAt;
      if (endedAt == null) continue;

      final day = DateTime(endedAt.year, endedAt.month, endedAt.day);
      final durationsByTask = durationsByDay.putIfAbsent(day, () => {});
      durationsByTask.update(
        session.taskId,
        (duration) => duration + session.duration(),
        ifAbsent: session.duration,
      );
    }

    return durationsByDay.entries
        .map(
          (dayEntry) => _TaskDay(
            date: dayEntry.key,
            tasks: dayEntry.value.entries
                .map(
                  (taskEntry) => _CompletedTask(
                    taskId: taskEntry.key,
                    duration: taskEntry.value,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}

class _TaskDaySection extends StatelessWidget {
  const _TaskDaySection({required this.section, required this.tasks});

  final _TaskDay section;
  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatTaskDay(section.date), style: context.t.headlineLarge),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _formatDuration(section.totalDuration),
                style: context.t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.c.onSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section.tasks.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final completedTask = section.tasks[index];

            return CompletedTaskCard(
              taskId: completedTask.taskId,
              duration: completedTask.duration,
              task: _findTask(tasks, completedTask.taskId),
            );
          },
        ),
      ],
    );
  }

  TaskEntity? _findTask(List<TaskEntity> tasks, String id) {
    for (final task in tasks) {
      if (task.id == id) return task;
    }

    return null;
  }
}

class _TaskDay {
  const _TaskDay({required this.date, required this.tasks});

  final DateTime date;
  final List<_CompletedTask> tasks;

  Duration get totalDuration =>
      tasks.fold(Duration.zero, (total, task) => total + task.duration);
}

class _CompletedTask {
  const _CompletedTask({required this.taskId, required this.duration});

  final String taskId;
  final Duration duration;
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.toString(),
        style: context.t.bodyMedium?.copyWith(color: context.c.error),
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
