class AppRoutes {
  AppRoutes._();

  static final String splash = '/splash';
  static final String onboarding = '/onboarding';
  static final String home = '/home';
  static final String allTasks = '/tasks';
  static final String task = '/task/:taskId';
  static final String analytics = '/analytics';

  static String taskPath(String taskId) => '/task/$taskId';
}
