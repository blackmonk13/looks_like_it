import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/app_startup.dart';
import 'package:looks_like_it/pages/home_page.dart';
import 'package:looks_like_it/providers/common.dart';

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      loading: () => const AppStartupLoadingWidget(),
      error: (error, stackTrace) => AppStartupErrorWidget(
        error: error,
        stackTrace: stackTrace,
        onRetry: () => ref.refresh(appStartupProvider.future),
      ),
      data: (_) => const HomePage(),
      // data: (_) => const AppStartupLoadingWidget(),
    );
  }
}

class ImageHashApp extends ConsumerWidget {
  const ImageHashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const seedColor = Color.fromARGB(255, 0, 38, 255);
    return Layout(
      format: MaterialLayoutFormat(),
      child: MaterialApp(
        title: 'Looks Like It',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
            dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
          ),
          useMaterial3: true,
        ),
        // themeMode: ThemeMode.light,
        themeMode: ThemeMode.system,
        home: const AppStartupWidget(),
      ),
    );
  }
}
