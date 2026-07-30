import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/tv_theme.dart';
import 'core/utils/tv_detector.dart';
import 'routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NoleLamPhimApp()));
}

class NoleLamPhimApp extends ConsumerWidget {
  const NoleLamPhimApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTv = TvDetector.isTv(context);

    if (isTv) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    return MaterialApp.router(
      title: 'Nô Lệ Làm Phim',
      debugShowCheckedModeBanner: false,
      theme: isTv ? TvTheme.dark : AppTheme.dark,
      routerConfig: appRouter(context),
    );
  }
}
