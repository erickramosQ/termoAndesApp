import 'package:flutter/material.dart';

import 'router.dart';
import 'shared/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Termoandes App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
