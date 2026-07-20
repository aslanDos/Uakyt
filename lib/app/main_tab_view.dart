import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uakyt/core/extensions/theme_x.dart';
import 'package:uakyt/core/widgets/navbar.dart';
import 'package:uakyt/core/widgets/pressable.dart';
import 'package:uakyt/features/analytics/presentation/pages/analytics_page.dart';
import 'package:uakyt/features/home/presentation/pages/home_page.dart';
import 'package:uakyt/features/task/presentation/pages/tasks.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _currentIndex,
    );

    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateTo(int index) {
    if (index == _tabController.index) {}
    _tabController.animateTo(index);
  }

  Future<void> _navigateToTasks({required BuildContext context}) async {
    await showTasksModal(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [HomePage(), AnalyticsPage()],
      ),
      bottomNavigationBar: SizedBox(
        height: 98,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: NavBar(activeIndex: _currentIndex, onTap: _navigateTo),
            ),
            Positioned(
              child: FABButton(
                icon: LucideIcons.plus,
                onTap: () => _navigateToTasks(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FABButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const FABButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: context.c.onSurface,
        ),
        child: Icon(icon, color: context.c.surface, size: 24),
      ),
    );
  }
}
