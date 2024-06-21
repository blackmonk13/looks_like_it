import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/compare_info_view.dart';
import 'package:looks_like_it/models/similar_image/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';

class GroupsView extends HookConsumerWidget {
  final ({SimilarImage image, List<SimilarImage> similarities}) data;
  const GroupsView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectionGroupProvider);
    return Container(
      color: context.colorScheme.surfaceContainer,
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(
            flex: 7,
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: ImageCompareView(
                          data: data,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2.0,
                ),
                Flexible(
                  // width: MediaQuery.of(context).size.width * .75,
                  child: CompareInfoView(
                    data: data,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 2.0,
          ),
          Flexible(
            child: Center(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                shrinkWrap: true,
                itemCount: data.similarities.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  final item = data.similarities.elementAt(index);
                  final imagePath = item.imagePath;
                  final selected = selectedGroup.selectedSimilarity == index;
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(selectionGroupProvider.notifier)
                          .selectSimilarity(index);
                    },
                    child: SizedBox.square(
                      dimension: 95.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: context.colorScheme.surfaceContainerHigh,
                          border: selected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3.0,
                                )
                              : null,
                          image: imagePath == null
                              ? null
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ResizeImage(
                                    width: 95,
                                    height: 95,
                                    policy: ResizeImagePolicy.fit,
                                    ref.read(fileImageProvider(imagePath)),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCompareView extends HookConsumerWidget {
  const ImageCompareView({
    super.key,
    required this.data,
  });

  final ({SimilarImage image, List<SimilarImage> similarities}) data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectionGroupProvider);

    final selectedSimilarity = useMemoized(
      () {
        if (data.similarities.isEmpty) {
          return null;
        }

        final item =
            data.similarities.elementAt(selectedGroup.selectedSimilarity);
        return item;
      },
      [selectedGroup],
    );
    return Row(
      children: [
        Flexible(
          child: ImageContainer(
            image: data.image,
          ),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        Flexible(
          child: ImageContainer(
            image: selectedSimilarity,
          ),
        ),
      ],
    );
  }
}

class ImageContainer extends ConsumerWidget {
  const ImageContainer({
    super.key,
    this.image,
  });

  final SimilarImage? image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = image?.imagePath;
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(5.0),
        image: imagePath == null
            ? null
            : DecorationImage(
                fit: BoxFit.contain,
                image: ref.read(fileImageProvider(imagePath)),
              ),
      ),
    );
  }
}
