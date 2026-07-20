import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/app/router/routes.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/action_button.dart';
import 'package:uakyt/core/widgets/task_card.dart';
import 'package:uakyt/features/task/presentation/pages/task_form.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';

Future<bool?> showTasksModal({required BuildContext context}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    barrierColor: Colors.black54,
    backgroundColor: context.c.surfaceContainer,
    builder: (context) => Tasks(),
  );
}

class Tasks extends ConsumerWidget {
  const Tasks({super.key});

  Future<void> _navigateToTaskForm({required BuildContext context}) async {
    await showTaskFormModal(context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          children: [
            //Header
            Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    'Tasks',
                    style: context.t.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: ActionButton(
                    onTap: () => _navigateToTaskForm(context: context),
                    icon: HeroIcons.plus,
                  ),
                ),
              ],
            ),

            // Tasks
            const SizedBox(height: 16),
            Expanded(
              child: tasks.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks yet',
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return TaskCard(
                        task: task,
                        onTap: () {
                          context.pop();
                          context.push(AppRoutes.taskPath(task.id));
                        },
                      );
                    },
                  );
                },
                error: (error, _) => Center(
                  child: Text(
                    error.toString(),
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.error,
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
