import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/pressable.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';
import 'package:uakyt/features/task_session/presentation/providers/task_sessions_provider.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  late final Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final sessions = ref.watch(taskSessionsProvider);

    return tasks.when(
      data: (tasks) {
        final task = _findTask(tasks, widget.taskId);

        if (task == null) {
          return const Scaffold(body: Center(child: Text('Task not found')));
        }

        return sessions.when(
          data: (sessions) {
            final currentSession = sessions.currentSession;
            final isCurrentTaskActive =
                currentSession != null && currentSession.taskId == task.id;
            final hasAnotherActiveTask =
                currentSession != null && currentSession.taskId != task.id;
            final elapsed = isCurrentTaskActive
                ? currentSession.duration(now: _now)
                : Duration.zero;

            return Scaffold(
              appBar: AppBar(
                leading: Pressable(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: HeroIcon(HeroIcons.arrowLeft, size: 24),
                ),
                centerTitle: true,
                title: Text(task.name, style: context.t.headlineLarge),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 110,
                            animation: true,
                            animationDuration: 800,
                            lineWidth: 15.0,
                            linearGradient: LinearGradient(
                              colors: [Colors.white, Color(task.colorValue)],
                            ),
                            percent: isCurrentTaskActive ? 1.0 : 0.0,
                            center: Text(
                              _formatDuration(elapsed),
                              style: context.t.displayLarge,
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Color(
                              task.colorValue,
                            ).withValues(alpha: 0.1),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: _TaskSessionControls(
                            isCurrentTaskActive: isCurrentTaskActive,
                            hasAnotherActiveTask: hasAnotherActiveTask,
                            onStart: () => ref
                                .read(taskSessionsProvider.notifier)
                                .startSession(task.id),
                            onStop: () => ref
                                .read(taskSessionsProvider.notifier)
                                .finishCurrentSession(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, _) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
      error: (error, _) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
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
}

class _TaskSessionControls extends StatelessWidget {
  const _TaskSessionControls({
    required this.isCurrentTaskActive,
    required this.hasAnotherActiveTask,
    required this.onStart,
    required this.onStop,
  });

  final bool isCurrentTaskActive;
  final bool hasAnotherActiveTask;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    if (hasAnotherActiveTask) {
      return Text(
        'Another task is active',
        style: context.t.bodyMedium?.copyWith(
          color: context.c.onSurfaceVariant,
        ),
      );
    }

    final action = isCurrentTaskActive
        ? (icon: HeroIcons.stop, label: 'Stop', onTap: onStop)
        : (icon: HeroIcons.play, label: 'Start', onTap: onStart);

    return Pressable(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.c.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(action.icon, size: 24, style: HeroIconStyle.solid),
          ),
          const SizedBox(height: 16),
          Text(action.label, style: context.t.bodySmall),
        ],
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
