import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/data/similarities_repository.dart';
import 'package:looks_like_it/hooks/undo_history.dart';

import 'package:looks_like_it/pages/scan_page.dart';
import 'package:looks_like_it/providers/files.dart';
import 'package:looks_like_it/utils/extensions.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanDirectory = ref.watch(directoryPickerProvider);
    final executablePath = ref.watch(similaritiesExecutableProvider);
    final recentPaths = ref.watch(recentPathsProvider);
    final textController = useTextEditingController(text: scanDirectory);
    final undoController = useUndoHistoryController();
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surfaceContainer,
        actions: [
          IconButton(
            tooltip: executablePath,
            icon: Icon(
              executablePath == null
                  ? FluentIcons.app_folder_24_regular
                  : FluentIcons.app_folder_24_filled,
            ),
            onPressed: () async {
              await ref
                  .read(similaritiesExecutableProvider.notifier)
                  .pickExecutable();
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: context.layout.value(
            xs: context.screenWidth * .8,
            md: 900,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              recentPaths.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return const Spacer();
                },
                error: (error, stackTrace) {
                  return const SizedBox.shrink();
                },
                loading: () {
                  return const SizedBox.shrink();
                },
              ),
              TextField(
                autofocus: true,
                controller: textController,
                undoController: undoController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(16.0),
                  suffix: IconButton(
                    onPressed: () async {
                      final folderPath = await ref
                          .read(
                            directoryPickerProvider.notifier,
                          )
                          .pickFolder();
                      if (folderPath == null) {
                        return;
                      }
                      textController.text = folderPath;
                    },
                    icon: const Icon(
                      FluentIcons.folder_24_regular,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              [executablePath, scanDirectory].any(
                (element) => element == null,
              )
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            await ref
                                .read(recentPathsProvider.notifier)
                                .add(scanDirectory!);
                            if (context.mounted) {
                              Navigator.of(context).push(
                                routeTo(page: const ScanPage()),
                              );
                            }
                          },
                          tooltip: "Find Similarities",
                          icon: const Icon(
                            FluentIcons.scan_object_24_regular,
                          ),
                          label: const Text("Find Similarities"),
                        ),
                        const ViewSimilaritiesBtn(),
                      ],
                    ),
              const SizedBox(
                height: 30.0,
              ),
              recentPaths.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Recent",
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: data.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  final folderPath = ref
                                      .read(
                                        directoryPickerProvider.notifier,
                                      )
                                      .setFolder(data.elementAt(index));

                                  if (folderPath == null) {
                                    return;
                                  }
                                  textController.text = folderPath;
                                },
                                leading: const Icon(
                                  FluentIcons.folder_24_regular,
                                ),
                                title: Text(
                                  data.elementAt(index),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return const SizedBox.shrink();
                },
                loading: () {
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewSimilaritiesBtn extends ConsumerWidget {
  const ViewSimilaritiesBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanDirectory = ref.watch(directoryPickerProvider);
    final repository = ref.watch(similaritiesRepositoryProvider);

    if (scanDirectory == null || repository.folderPath == null) {
      return const SizedBox.shrink();
    }

    if (scanDirectory != repository.folderPath) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          routeTo(page: const ScanPage()),
        );
      },
      tooltip: "View Similarities",
      icon: const Icon(
        FluentIcons.content_view_24_regular,
      ),
      label: const Text("View Similarities"),
    );
  }
}
