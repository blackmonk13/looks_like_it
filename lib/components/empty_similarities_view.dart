import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:looks_like_it/utils/extensions.dart';

class EmptySimilaritiesView extends StatelessWidget {
  const EmptySimilaritiesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.image_prohibited_24_regular,
            size: 100,
            color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
          ),
          Text(
            "No similarities found",
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
            ),
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
    );
  }
}
