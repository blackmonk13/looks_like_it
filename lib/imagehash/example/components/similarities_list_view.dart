import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/imagehash/example/components/similarity_list_tile.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesListView extends HookConsumerWidget {
  const SimilaritiesListView({
    super.key,
    required this.itemCount,
  });
  final int itemCount;

  static const pageSize = 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final scrollPosition = ref.watch(scrollPositionProvider("sim_list"));
    final selectedIndex = ref.watch(selectedIndexProvider);

    final textStyle = context.textTheme.labelSmall;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollPosition);
      });

      scrollController.addListener(() {
        ref
            .read(scrollPositionProvider("sim_list").notifier)
            .updatePosition(scrollController.offset);
      });
      return () => scrollController.removeListener(() {
            ref
                .read(scrollPositionProvider("sim_list").notifier)
                .updatePosition(scrollController.offset);
          });
    }, const []);

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () async {
          if (selectedIndex <= 0) {
            ref.read(selectedIndexProvider.notifier).select(itemCount - 1);
          } else {
            ref.read(selectedIndexProvider.notifier).select(selectedIndex - 1);
          }
          scrollController.jumpTo(selectedIndex * 60);
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () async {
          if (selectedIndex >= itemCount - 1) {
            ref.read(selectedIndexProvider.notifier).select(0);
          } else {
            ref.read(selectedIndexProvider.notifier).select(selectedIndex + 1);
          }
          scrollController.jumpTo(selectedIndex * 60);
        },
      },
      child: Focus(
        autofocus: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "${itemCount.toString()} Pairs",
                    style: textStyle?.copyWith(
                      color: textStyle.color?.withOpacity(.4),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const FiltersDialog();
                        },
                      );
                    },
                    icon: const Icon(
                      FluentIcons.filter_24_regular,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: .5,
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: itemCount,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    thickness: .5,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final page = index ~/ pageSize;
                  final offset = page * pageSize;
                  final indexInPage = index % pageSize;
                  final asyncSimilarities = ref.watch(similaritiesQueryProvider(
                    limit: pageSize,
                    offset: offset,
                  ));

                  return asyncSimilarities.when(
                    data: (data) {
                      final item = data.elementAt(indexInPage);
                      return SimilarityListTile(
                        key: ValueKey(item),
                        selected: selectedIndex == index,
                        item: item,
                        onTap: () {
                          ref
                              .read(selectedIndexProvider.notifier)
                              .select(index);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                    loading: () {
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FiltersDialog extends HookConsumerWidget {
  const FiltersDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathFilters = ref.watch(pathFiltersProvider);
    return Dialog(
      alignment: AlignmentDirectional.centerStart,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.surfaceContainerHigh,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        width: context.layout.value(
          xs: context.screenWidth * .8,
          sm: 600.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  "Filters",
                  style: context.textTheme.headlineSmall,
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: pathFilters.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    thickness: .5,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  final item = pathFilters.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(item),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(pathFiltersProvider.notifier)
                            .toggleFilter(item);
                      },
                      icon: const Icon(
                        FluentIcons.dismiss_24_regular,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
