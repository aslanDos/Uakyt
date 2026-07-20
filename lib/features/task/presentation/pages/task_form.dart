import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:uakyt/core/constants/app_icons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/action_button.dart';
import 'package:uakyt/core/widgets/button.dart';
import 'package:uakyt/core/widgets/category_picker.dart';
import 'package:uakyt/core/widgets/color_picker.dart';
import 'package:uakyt/core/widgets/custom_text_field.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';

Future<bool?> showTaskFormModal({required BuildContext context}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    barrierColor: Colors.black54,
    backgroundColor: context.c.surfaceContainer,
    builder: (context) => TaskForm(),
  );
}

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({super.key});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  int _selectedIndex = 0;
  AppIcon _selectedIcon = AppIcon.archive;
  final TextEditingController _controller = TextEditingController();

  static const List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      return;
    }

    final task = TaskEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      iconName: _selectedIcon.name,
      colorValue: _colors[_selectedIndex].toARGB32(),
      createdAt: DateTime.now(),
    );

    await ref.read(tasksProvider.notifier).createTask(task);

    if (!mounted) {
      return;
    }

    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Header
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              ActionButton(onTap: () => context.pop(), icon: HeroIcons.xMark),
              Text('New Task', style: context.t.titleLarge),
              // If existing taskForm then no delete
              ActionButton(onTap: () {}, icon: HeroIcons.trash),
            ],
          ),
          const SizedBox(height: 32),
          // Icon Circle
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: .circle,
              color: _colors[_selectedIndex],
            ),
            child: Icon(
              _selectedIcon.icon,
              size: 36,
              color: context.c.onPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // Color Picker
          ColorPicker(
            colors: _colors,
            selectedIndex: _selectedIndex,
            onChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Icon Picker
          const SizedBox(height: 2),

          CategoryPicker(
            icons: AppIcon.values,
            selectedIcon: _selectedIcon,
            onChanged: (icon) {
              setState(() {
                _selectedIcon = icon;
              });
            },
          ),
          const SizedBox(height: 2),
          // Name picker
          CustomTextField(controller: _controller, hintText: 'Task name'),
          // Duration picker
          const SizedBox(height: 8),

          Button(label: 'Save', onPressed: _saveTask),
        ],
      ),
    );
  }
}
