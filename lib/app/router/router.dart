import 'package:go_router/go_router.dart';
import 'package:uakyt/app/main_tab_view.dart';
import 'package:uakyt/app/router/routes.dart';
import 'package:uakyt/features/splash/presentation/pages/spash_page.dart';
import 'package:uakyt/features/task/presentation/pages/all_tasks_page.dart';
import 'package:uakyt/features/task/presentation/pages/task_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MainTabView()),
      ),
      GoRoute(
        path: AppRoutes.allTasks,
        builder: (context, state) => const AllTasksPage(),
      ),
      GoRoute(
        path: AppRoutes.task,
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskPage(taskId: taskId);
        },
      ),
    ],
  );
}
