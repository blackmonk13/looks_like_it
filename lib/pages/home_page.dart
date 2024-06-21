import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/pages/scan_page.dart';
import 'package:looks_like_it/providers/common.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanDirectory = ref.watch(directoryPickerProvider);
    final executablePath = ref.watch(similaritiesExecutableProvider);
    final textController = useTextEditingController(text: scanDirectory);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Home"),
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TextFormField(),
            SizedBox(
              width: 500,
              child: TextField(
                controller: textController,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            MaterialButton(
              onPressed: () async {
                final searchDir = await ref
                    .read(
                      directoryPickerProvider.notifier,
                    )
                    .pickFolder();
                if (searchDir == null) {
                  return;
                }
                textController.text = searchDir;
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Browse"),
            ),
          ],
        ),
      ),
      floatingActionButton: [executablePath, scanDirectory].any(
        (element) => element == null,
      )
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const ScanPage();
                    },
                  ),
                );
              },
              tooltip: 'Scan',
              child: const Icon(
                FluentIcons.scan_object_24_regular,
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
