import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SettingsBtn extends ConsumerWidget {
  const SettingsBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: "Settings",
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return const SettingsDialog();
          },
        );
      },
      icon: const Icon(
        FluentIcons.settings_20_regular,
        size: 20,
      ),
    );
  }
}

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.surfaceContainerHigh,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        width: context.layout.value(
          xs: context.screenWidth * .8,
          sm: 600.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                FluentIcons.settings_32_regular,
              ),
              title: Text(
                "Settings",
                style: context.textTheme.headlineSmall,
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () async {
                await ref
                    .read(imagesProcessingProvider)
                    .requireValue
                    .clearSimilarities();
              },
              title: Text(
                "Clear Similarities",
                style: context.textTheme.labelLarge,
              ),
            ),
            ListTile(
              onTap: () async {
                await ref
                    .read(imagesProcessingProvider)
                    .requireValue
                    .clearEntries();
              },
              title: Text(
                "Wipe Database",
                style: context.textTheme.labelLarge,
              ),
            )
          ],
        ),
      ),
    );
  }
}
