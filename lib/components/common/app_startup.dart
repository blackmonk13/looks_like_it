import 'package:flutter/material.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/utils/extensions.dart';

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: context.screenWidth * .3,
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });
  final Object? error;
  final StackTrace? stackTrace;
  final RefreshCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AsyncErrorView(
        error: error,
        stackTrace: stackTrace,
        onRefresh: onRetry,
      ),
    );
  }
}
