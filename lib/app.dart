import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saqia/core/router/app_router.dart';
import 'package:saqia/core/state/saqia_state.dart';
import 'package:saqia/core/theme/app_theme.dart';

class SaqiaApp extends StatelessWidget {
  const SaqiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SaqiaState(),
      child: Builder(
        builder: (context) {
          final router = AppRouter.create(context.read<SaqiaState>());
          return MaterialApp.router(
            title: 'Saqia',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
