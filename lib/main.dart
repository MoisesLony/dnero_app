  import 'package:dnero_app_prueba/config/app_route/app_router.dart';
  import 'package:dnero_app_prueba/config/theme/app_theme.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import 'presentation/screens/screens_barril.dart';


  void main() {
    runApp(
      const ProviderScope( // Wrap the app in a ProviderScope
        child: DNERO_APP(),
      ),
    );
  }

  class DNERO_APP extends StatelessWidget {
    const DNERO_APP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Authentication App',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,

    );
  }
  }