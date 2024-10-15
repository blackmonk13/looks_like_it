import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/hooks/undo_history.dart';
import 'package:looks_like_it/components/similarity_picker.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as path;

class FolderNavigationWidget extends HookConsumerWidget {
  const FolderNavigationWidget({
    super.key,
    required this.initialPath,
    required this.recentLocations,
    required this.onPathChanged,
    required this.onRecentChanged,
    required this.onRefresh,
  });
  final String initialPath;
  final List<String> recentLocations;
  final ValueChanged<String> onPathChanged;
  final ValueChanged<List<String>> onRecentChanged;
  final RefreshCallback onRefresh;
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

      if (isEditing.value || pathController.text.isEmpty) {
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
          recentLocations: recentLocations,
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
              // style: const ButtonStyle(
              //   visualDensity: VisualDensity.compact,
              //   minimumSize: WidgetStatePropertyAll(Size.fromWidth(24)),
              //   maximumSize: WidgetStatePropertyAll(Size.fromWidth(28)),
              //   // padding: WidgetStatePropertyAll(
              //   //   EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              //   // ),
              // ),
              iconSize: 20,
              position: PopupMenuPosition.under,
              tooltip: "History",
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              icon: const Icon(
                FluentIcons.history_20_regular,
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
            if (pathController.text.isNotEmpty &&
                Directory(pathController.text).parent.existsSync())
              IconButton(
                icon: const Icon(
                  FluentIcons.arrow_up_20_regular,
                  size: 20,
                ),
                onPressed: () {
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
        const SizedBox(width: 8),
        if (pathController.text.isNotEmpty)
          RefreshBtn(
            onRefresh: onRefresh,
          ),
        IconButton(
          onPressed: () async {
            String? folderPath = await FilePicker.platform.getDirectoryPath();

            if (folderPath == null) {
              // User canceled the picker
              return;
            }
            navigateTo(folderPath);
          },
          icon: const Icon(
            FluentIcons.folder_20_regular,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class RefreshBtn extends StatelessWidget {
  const RefreshBtn({
    super.key,
    required this.onRefresh,
  });

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Refresh",
      onPressed: onRefresh,
      icon: const Icon(
        FluentIcons.arrow_clockwise_20_regular,
        size: 20,
      ),
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
    required this.recentLocations,
  });

  final ValueNotifier<bool> isEditing;
  final BoxConstraints boxConstraints;
  final List<String> pathParts;
  final TextStyle? textTheme;
  final ValueChanged<String> onNavigate;
  final List<String> recentLocations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => isEditing.value = true,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        constraints: boxConstraints,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...context.layout.value<List<Widget>>(
                xs: _buildSmallScreenBreadcrumbs(context),
                sm: _buildSmallScreenBreadcrumbs(context),
                md: _buildLargeScreenBreadcrumbs(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSmallScreenBreadcrumbs(BuildContext context) {
    final visibleCount = context.layout.value<int>(
      xs: 1,
      sm: Layout.of(context).width <= 600
          ? 2
          : context.layout.width <= 700
              ? 3
              : 4,
    );

    if (pathParts.length <= visibleCount) {
      return [];
    }

    final hiddenParts = pathParts.length <= visibleCount
        ? <String>[]
        : pathParts.sublist(0, pathParts.length - visibleCount);
    final visibleParts = pathParts.length <= visibleCount
        ? pathParts
        : pathParts.sublist(pathParts.length - visibleCount);

    return [
      if (hiddenParts.isNotEmpty) _buildHiddenPartsButton(context, hiddenParts),
      ...visibleParts.asMap().entries.expand((entry) {
        int idx = entry.key;
        String part = entry.value;
        final thisPathList =
            pathParts.sublist(0, pathParts.length - visibleCount + idx + 1);
        final thisPath = path.joinAll(thisPathList);

        final partBtn = PathPartBtn(
          part: part,
          fullPath: thisPath,
          textTheme: textTheme,
          onNavigate: onNavigate,
        );
        if (idx < visibleParts.length - 1) {
          return [
            partBtn,
            BreadcrumbDropdownBtn(
              folderPath: thisPath,
              textTheme: textTheme,
            ),
          ];
        }
        return [partBtn];
      }),
    ];
  }

  List<Widget> _buildLargeScreenBreadcrumbs() {
    return pathParts.asMap().entries.expand((entry) {
      int idx = entry.key;
      String part = entry.value;
      final thisPathList = pathParts.sublist(0, idx + 1);
      final thisPath = path.joinAll(thisPathList);

      final partBtn = PathPartBtn(
        part: part,
        fullPath: thisPath,
        textTheme: textTheme,
        onNavigate: onNavigate,
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
    }).toList();
  }

  Widget _buildHiddenPartsButton(
    BuildContext context,
    List<String> hiddenParts,
  ) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      tooltip: "Other Locations",
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
          EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.chevron_double_left_20_regular,
            size: textTheme?.fontSize,
          ),
          const SizedBox(width: 4),
        ],
      ),
      itemBuilder: (BuildContext context) => [
        ...hiddenParts
            .map((part) {
              return PopupMenuItem<String>(
                value: part,
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
                      part,
                      style: textTheme,
                    ),
                  ],
                ),
              );
            })
            .toList()
            .reversed,
        const PopupMenuDivider(),
        ...recentLocations.take(3).map((location) {
          return PopupMenuItem<String>(
            value: location,
            child: Tooltip(
              message: location,
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
                    path.basename(location),
                    style: textTheme,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
      onSelected: (String value) {
        if (hiddenParts.contains(value)) {
          final index = hiddenParts.indexOf(value);
          final selectedPath = path.joinAll(pathParts.sublist(0, index + 1));
          onNavigate(selectedPath);
        } else {
          onNavigate(value); // For recent locations
        }
      },
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
