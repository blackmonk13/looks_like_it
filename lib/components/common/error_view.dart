import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ErrorMsg {
  final String code;
  final String brief;
  final String? details;
  final String? solution;

  ErrorMsg({
    this.code = "0000",
    this.brief = "Unknown error",
    this.details,
    this.solution,
  });
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.errorMsg,
    this.onRefresh,
    this.additionalText = const [],
    this.trailing = const [],
    this.builder,
  });

  final ErrorMsg errorMsg;
  final RefreshCallback? onRefresh;
  final List<InlineSpan> additionalText;
  final List<Widget> trailing;
  final Widget Function(
    BuildContext context,
    ErrorMsg errorMsg,
  )? builder;

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return builder!(context, errorMsg);
    }

    return SingleChildScrollView(
      primary: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.warning_20_regular,
            size: MediaQuery.of(context).size.shortestSide * .15,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Oops, something went wrong.\n\n',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Error ${errorMsg.code}: ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextSpan(
                      text: errorMsg.brief,
                      
                    ),
                    const TextSpan(text: "\n\n")
                  ],
                ),
                if (errorMsg.details != null)
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Details\n',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: "${errorMsg.details}\n\n",
                      ),
                    ],
                  ),
                if (errorMsg.solution != null)
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Solution\n",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: "${errorMsg.solution}\n\n",
                      ),
                    ],
                  ),
                const TextSpan(
                  text:
                      "If you need further assistance, please reach out to our support team.",
                ),
                ...additionalText,
              ],
            ),
            textAlign: TextAlign.center,
          ),
          if (onRefresh != null)
            ElevatedButton.icon(
              onPressed: () async {
                await onRefresh?.call();
              },
              icon: const Icon(
                FluentIcons.arrow_reset_24_regular,
              ),
              label: const Text(
                "Try Again",
              ),
            ),
          ...trailing,
        ],
      ),
    );
  }
}

class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({
    super.key,
    required this.error,
    required this.stackTrace,
    this.onRefresh,
    this.additionalText = const [],
    this.trailing = const [],
    this.builder,
  });
  final Object? error;
  final StackTrace? stackTrace;
  final RefreshCallback? onRefresh;
  final List<InlineSpan> additionalText;
  final List<Widget> trailing;
  final Widget Function(
    BuildContext context,
    ErrorMsg errorMsg,
  )? builder;

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final pageError = ErrorMsg(
      code: random.nextInt(9999).toString(),
      brief: error.toString(),
      details: stackTrace.toString(),
    );

    return ErrorView(
      errorMsg: pageError,
      builder: builder,
      onRefresh: onRefresh,
      additionalText: additionalText,
      trailing: trailing,
    );
  }
}
