import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesErrorView extends StatelessWidget {
  const SimilaritiesErrorView({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.warning_24_regular,
              size: 100,
              color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
            ),
            Text(
              "Oops! Something went wrong.",
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
              ),
            ),
            Text(
              error.toString(),
            ),
            Text(
              stackTrace.toString(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              label: Text(
                "Go Back",
                style: TextStyle(
                  color: context.colorScheme.onSurfaceVariant.withOpacity(.8),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
