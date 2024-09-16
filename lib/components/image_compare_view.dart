import 'package:before_after/before_after.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/hooks/photo_view.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/providers/ui.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';

class ImageCompareView extends HookConsumerWidget {
  const ImageCompareView({
    super.key,
    required this.data,
  });

  final SimilarImage data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedSimilarityProvider);
    final viewMode = ref.watch(imageViewModeProvider);

    final splitPosition = useState<double>(.5);
    final scaleController = usePhotoViewScaleStateController();
    // final controller = usePhotoViewController();

    return viewMode
        ? BeforeAfter(
            autofocus: true,
            trackWidth: 2.0,
            trackColor: context.colorScheme.outlineVariant,
            thumbColor: context.colorScheme.outlineVariant,
            value: splitPosition.value,
            onValueChanged: (value) {
              splitPosition.value = value;
            },
            before: ImageView(
              // controller: controller,
              scaleController: scaleController,
              image: data,
            ),
            after: ImageView(
              // controller: controller,
              scaleController: scaleController,
              image: data.similarities.elementAt(selectedId),
            ),
          )
        : Row(
            children: [
              Flexible(
                child: ImageView(
                  // controller: controller,
                  scaleController: scaleController,
                  image: data,
                ),
              ),
              const VerticalDivider(
                width: 2.0,
              ),
              Flexible(
                child: ImageView(
                  // controller: controller,
                  scaleController: scaleController,
                  image: data.similarities.elementAt(selectedId),
                ),
              ),
            ],
          );
  }
}

class ImageView extends HookConsumerWidget {
  const ImageView({
    super.key,
    required this.image,
    required this.scaleController,
    this.controller,
  });
  final SimilarImage image;
  final PhotoViewScaleStateController scaleController;
  final PhotoViewController? controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = usePhotoViewController(initialScale: 1.0);

    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: PhotoView(
        controller: controller,
        scaleStateController: scaleController,
        imageProvider: ref.read(fileImageProvider(image.imagePath)),
        
        filterQuality: FilterQuality.high,
        backgroundDecoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHigh,
        ),
      ),
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
        color: context.colorScheme.surfaceContainerHigh,
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

class ImageViewModeBtn extends ConsumerWidget {
  const ImageViewModeBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(imageViewModeProvider);
    return IconButton(
      onPressed: () {
        ref.read(imageViewModeProvider.notifier).toggle();
      },
      isSelected: viewMode,
      icon: const Icon(
        FluentIcons.image_split_24_regular,
      ),
      selectedIcon: const Icon(
        FluentIcons.image_split_24_filled,
      ),
    );
  }
}
