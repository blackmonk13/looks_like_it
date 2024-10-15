import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/components/scan_loader.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/extensions.dart';

class EmptySimilaritiesView extends ConsumerWidget {
  const EmptySimilaritiesView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCompare = ref.watch(comparisonControllerProvider);
    // final folderPath = ref.watch(directoryPickerProvider);
    // return const ScanLoader();
    return asyncCompare.when(
      data: (data) {
        if (data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await ref
                        .read(directoryPickerProvider.notifier)
                        .pickFolder();
                  },
                  icon: Icon(
                    FluentIcons.folder_add_48_filled,
                    size: 58,
                    color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(directoryPickerProvider.notifier)
                        .pickFolder();
                  },
                  child: Text(
                    "Choose Folder",
                    style: context.textTheme.headlineSmall?.copyWith(
                      color:
                          context.colorScheme.onSurfaceVariant.withOpacity(.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/images/empty_box.svg",
                color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
              ),
              Text(
                "No similarities found",
                style: context.textTheme.headlineSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withOpacity(.5),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return const ScanLoader();
      },
    );
  }
}
