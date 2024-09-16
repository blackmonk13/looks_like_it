import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/groups_view.dart';
import 'package:looks_like_it/components/image_similarities_view.dart';
import 'package:looks_like_it/data/similarities_repository.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';

import 'similarity_tile.dart';

class SimilaritiesView extends HookConsumerWidget {
  const SimilaritiesView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Flexible(
          flex: 2,
          child: ImagesListView(),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        const Flexible(
          flex: 6,
          child: GroupsView(),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        Flexible(
          flex: context.layout.value(xs: 0, md: 1),
          child: AdaptiveBuilder(
            xs: (context) {
              return const SizedBox.shrink();
            },
            md: (context) {
              return const ImageSimilaritiesView();
            },
          ),
        ),
      ],
    );
  }
}

class ImagesListView extends HookConsumerWidget {
  const ImagesListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(similarImagesWatcherProvider);
    final asyncCount = ref.watch(imagesCountProvider);
    final scrollController = useScrollController();
    const padding = EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 16.0,
    );

    return Container(
      color: context.colorScheme.surfaceContainer,
      child: Column(
        children: [
          const Row(
            children: [
              // IconButton(
              //   onPressed: () => showAll.value = !showAll.value,
              //   icon: const Icon(FluentIcons.list_24_filled),
              // ),
            ],
          ),
          Expanded(
            child: asyncCount.when(
              data: (count) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: count,
                  padding: padding,
                  itemBuilder: (BuildContext context, int index) {
                    final page = index ~/ 30;
                    final indexInPage = index % 30;

                    final asyncSimilarities =
                        ref.watch(pagedSimilaritiesProvider(page));

                    final selectedId =
                        ref.watch(selectedImageControllerProvider);

                    return asyncSimilarities.when(
                      data: (data) {
                        // This condition only happens if a null itemCount is given
                        if (indexInPage >= data.length) {
                          return null;
                        }
                        final item = data.elementAt(indexInPage);

                        final selected = selectedId == index;

                        return SimilarityTile(
                          key: Key(item.id.toString()),
                          onTap: () {
                            ref
                                .read(selectedImageControllerProvider.notifier)
                                .selectImage(index);
                          },
                          selected: selected,
                          image: item,
                        );
                      },
                      error: (error, stackTrace) {
                        return SimilarityTile(
                          error: (error: error, stackTrace: stackTrace),
                        );
                      },
                      loading: () {
                        return const SimilarityTile(
                          loading: true,
                        );
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return const SizedBox.shrink();
              },
              loading: () {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return const SimilarityTile(
                      loading: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
