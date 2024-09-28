import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/hooks/undo_history.dart';
import 'package:looks_like_it/imagehash/example/components/similarity_picker.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as path;

class FolderNavigationWidget extends HookConsumerWidget {
  const FolderNavigationWidget({
    super.key,
    required this.initialPath,
    required this.recentLocations,
    required this.onPathChanged,
    required this.onRecentChanged,
  });
  final String initialPath;
  final List<String> recentLocations;
  final ValueChanged<String> onPathChanged;
  final ValueChanged<List<String>> onRecentChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathController = useTextEditingController(text: initialPath);
    final isEditing = useState(false);
    final undoController = useUndoHistoryController();
    final currentPath = pathController.text;
    final textTheme = context.textTheme.labelMedium;

    useEffect(() {
      pathController.text = initialPath;
      return null;
    }, [initialPath]);

    void navigateTo(String path) {
      if (!Directory(path).existsSync()) {
        return;
      }

      if (pathController.text != path) {
        pathController.text = path;
      }

      onPathChanged(path);

      if (!recentLocations.contains(path)) {
        onRecentChanged([
          path,
          ...recentLocations.take(4),
        ]);
      }
    }

    Widget buildPathDisplay() {
      final fontSize = textTheme?.fontSize;
      final boxConstraints = BoxConstraints(
        minHeight: 8.0,
        maxHeight: fontSize == null ? double.infinity : fontSize + 16,
      );
      if (isEditing.value) {
        return TextField(
          controller: pathController,
          undoController: undoController,
          style: textTheme,
          onTapOutside: (event) {
            isEditing.value = false;
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            constraints: boxConstraints,
            // suffixIcon: InkWell(
            //   child: const Icon(
            //     FluentIcons.checkmark_24_regular,
            //   ),
            //   onTap: () {
            //     isEditing.value = false;
            //     navigateTo(pathController.text);
            //   },
            // ),
          ),
          onSubmitted: (value) {
            isEditing.value = false;
            navigateTo(value);
          },
        );
      } else {
        List<String> pathParts = path.split(currentPath);

        return BreadcrumbsBuilder(
          isEditing: isEditing,
          boxConstraints: boxConstraints,
          pathParts: pathParts,
          textTheme: textTheme,
          onNavigate: (String value) {
            navigateTo(value);
          },
        );
      }
    }

    return Row(
      children: [
        Row(
          children: [
            const SimilarityPicker(),
            // InkWell(
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            //     child: Icon(
            //       FluentIcons.arrow_left_24_regular,
            //       size: 20,
            //     ),
            //   ),
            //   onTap: () {/* Implement back navigation */},
            // ),
            // InkWell(
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            //     child: Icon(
            //       FluentIcons.arrow_right_24_regular,
            //       size: 20,
            //     ),
            //   ),
            //   onTap: () {/* Implement forward navigation */},
            // ),
            PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              icon: const Icon(
                FluentIcons.history_24_regular,
                size: 20,
              ),
              onSelected: (value) {
                navigateTo(value);
              },
              itemBuilder: (context) {
                return recentLocations.map((location) {
                  return PopupMenuItem(
                    value: location,
                    child: Text(
                      location,
                      style: textTheme,
                    ),
                  );
                }).toList();
              },
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: Icon(
                  FluentIcons.arrow_up_24_regular,
                  size: 20,
                ),
              ),
              onTap: () {
                final parentPath = path.dirname(currentPath);
                navigateTo(parentPath);
              },
            ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: buildPathDisplay(),
        ),
        InkWell(
          onTap: () async {
            final folderPath = await ref
                .read(
                  directoryPickerProvider.notifier,
                )
                .pickFolder();
            if (folderPath == null) {
              return;
            }
            pathController.text = folderPath;
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Center(
              child: Icon(
                FluentIcons.folder_24_regular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BreadcrumbsBuilder extends HookConsumerWidget {
  const BreadcrumbsBuilder({
    super.key,
    required this.isEditing,
    required this.boxConstraints,
    required this.pathParts,
    required this.textTheme,
    required this.onNavigate,
  });

  final ValueNotifier<bool> isEditing;
  final BoxConstraints boxConstraints;
  final List<String> pathParts;
  final TextStyle? textTheme;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => isEditing.value = true,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        constraints: boxConstraints,
        decoration: BoxDecoration(
          border: Border.all(color: context.colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: pathParts.asMap().entries.expand((entry) {
            int idx = entry.key;
            String part = entry.value;
            final thisPathList = pathParts.sublist(0, idx + 1);
            final thisPath = path.joinAll(thisPathList);

            // TODO:
            final partBtn = PathPartBtn(
              part: part,
              fullPath: thisPath,
              textTheme: textTheme,
              onNavigate: (value) {
                onNavigate(value);
              },
            );
            if (idx < pathParts.length - 1) {
              return [
                partBtn,
                BreadcrumbDropdownBtn(
                  folderPath: thisPath,
                  textTheme: textTheme,
                ),
              ];
            }
            return [partBtn];
          }).toList(),
        ),
      ),
    );
  }
}

class PathPartBtn extends HookConsumerWidget {
  const PathPartBtn({
    super.key,
    required this.part,
    required this.fullPath,
    required this.onNavigate,
    this.textTheme,
  });
  final String part;
  final String fullPath;
  final ValueChanged<String> onNavigate;
  final TextStyle? textTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        minimumSize: WidgetStatePropertyAll(Size.fromWidth(32)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
        ),
      ),
      onPressed: () {
        onNavigate(fullPath);
      },
      child: Text(
        part,
        style: textTheme,
      ),
    );
  }
}

class BreadcrumbDropdownBtn extends HookConsumerWidget {
  const BreadcrumbDropdownBtn({
    super.key,
    required this.folderPath,
    this.textTheme,
  });
  final String folderPath;
  final TextStyle? textTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFolders = ref.watch(listFoldersProvider(folderPath));

    return asyncFolders.when(
      data: (data) {
        return PopupMenuButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: context.colorScheme.surfaceContainerHigh,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            minimumSize: WidgetStatePropertyAll(Size.fromWidth(32)),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
            ),
          ),
          icon: icon(),
          position: PopupMenuPosition.under,
          constraints: const BoxConstraints(maxHeight: 400),
          itemBuilder: (context) {
            return data.map((pp) {
              return PopupMenuItem(
                value: pp,
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.folder_24_filled,
                      size: textTheme?.fontSize,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      path.basename(pp),
                      style: textTheme,
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
      error: (error, stackTrace) {
        return icon();
      },
      loading: () {
        return icon();
      },
    );
  }

  Widget icon() {
    return Icon(
      FluentIcons.chevron_right_24_regular,
      size: textTheme?.fontSize,
    );
  }
}
