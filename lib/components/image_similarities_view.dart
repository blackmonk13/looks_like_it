import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/groups_view.dart';
import 'package:looks_like_it/components/scan_loader.dart';
import 'package:looks_like_it/data/similarities_repository.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/constants.dart';
import 'package:looks_like_it/utils/extensions.dart';

class ImageSimilaritiesView extends ConsumerWidget {
  const ImageSimilaritiesView({super.key, this.horizontal = false});
  final bool horizontal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(similarImagesWatcherProvider);
    final asyncImage = ref.watch(selectedImageProvider);

    return asyncImage.when(
      data: (data) {
        if (data == null) {
          return const SizedBox.shrink();
        }
        return SimilaritiesList(
          similarities: data.similarities.toList(),
          horizontal: horizontal,
        );
      },
      error: (error, stackTrace) {
        return SimilaritiesList(
          error: true,
          horizontal: horizontal,
        );
      },
      loading: () {
        return SimilaritiesList(
          loading: true,
          horizontal: horizontal,
        );
      },
    );
  }
}

class SimilaritiesList extends HookConsumerWidget {
  const SimilaritiesList({
    super.key,
    this.similarities = const [],
    this.loading = false,
    this.error = false,
    this.horizontal = false,
  });
  final List<SimilarImage> similarities;
  final bool loading;
  final bool error;
  final bool horizontal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedSimilarityProvider);
    final scrollController = useScrollController();
    return Column(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                AnimatedCrossFade(
                  firstChild: Shimmered(
                    color: context.colorScheme.surfaceContainerHigh,
                    width: 14,
                    height: 14,
                  ),
                  secondChild: SelectSimilaritiesCheckBox(
                    similarities: similarities.toList(),
                  ),
                  crossFadeState: loading
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: animationDuration,
                )
              ],
            ),
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        Expanded(
          flex: 13,
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            // shrinkWrap: true,
            itemCount: loading ? 3 : similarities.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              if (loading) {
                return const SimilarTile(
                  loading: true,
                );
              }

              final item = similarities.elementAt(index);

              final selected = selectedId == index;
              return SimilarTile(
                selected: selected,
                image: item,
                onTap: () {
                  ref.read(selectedSimilarityProvider.notifier).selectId(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class SimilarTile extends ConsumerWidget {
  const SimilarTile({
    super.key,
    this.selected = false,
    this.image,
    this.onTap,
    this.loading = false,
  });

  final GestureTapCallback? onTap;
  final bool selected;
  final SimilarImage? image;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = image?.imagePath;
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedCrossFade(
          firstChild:
              Shimmered(color: context.colorScheme.surfaceContainerHigh),
          secondChild: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: context.colorScheme.surfaceContainerHigh,
              border: selected
                  ? Border(
                      left: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 5.0,
                      ),
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
          crossFadeState:
              loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: animationDuration,
        ),
      ),
    );
  }
}
