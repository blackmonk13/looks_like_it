import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/imagehash/example/components/similarity_list_tile.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesListView extends HookConsumerWidget {
  const SimilaritiesListView({
    super.key,
    required this.data,
    required this.selectedIndex,
  });
  final List<ImageSimilarity> data;
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelSmall;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Row(
            children: <Widget>[
              Text(
                "${data.length.toString()} Pairs",
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
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: .5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final item = data.elementAt(index);
              return SimilarityListTile(
                selected: selectedIndex.value == index,
                item: item,
                onTap: () {
                  selectedIndex.value = index;
                },
              );
            },
          ),
        ),
      ],
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
