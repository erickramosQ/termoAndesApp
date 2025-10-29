import 'package:go_router/go_router.dart';

import 'packages/navigation/navbar_pages.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: MainPages.name,
        builder: (context, state) => const MainPages(),
      ),
    ],
  );
}
