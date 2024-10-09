import 'dart:io';
import 'dart:math';
import 'package:before_after/before_after.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/hooks/photo_view.dart';
import 'package:looks_like_it/imagehash/example/components/similarities_details_view.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart' as path;

enum ImageViewMode {
  sideBySide,
  splitView,
  diffView,
}

class SimilaritiesPhotoViews extends HookConsumerWidget {
  const SimilaritiesPhotoViews({
    super.key,
    required this.itemCount,
  });
  final int itemCount;

  static const pageSize = 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fileOpsControllerProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final page = selectedIndex ~/ pageSize;
    final offset = page * pageSize;
    final indexInPage = selectedIndex % pageSize;
    final asyncSimilarities = ref.watch(similaritiesQueryProvider(
      limit: pageSize,
      offset: offset,
    ));

    final controller1 = usePhotoViewController();
    final controller2 = usePhotoViewController();
    final scaleStateController1 = usePhotoViewScaleStateController();
    final scaleStateController2 = usePhotoViewScaleStateController();

    final viewMode = useState<ImageViewMode>(ImageViewMode.sideBySide);

    final splitPosition = useState<double>(.5);

    final zoom = useState("");

    useEffect(() {
      void syncController2() {
        if (controller2.scale != controller1.scale) {
          controller2.scale = controller1.scale;
        }
        if (controller2.position != controller1.position) {
          controller2.position = controller1.position;
        }
        if (controller2.rotation != controller1.rotation) {
          controller2.rotation = controller1.rotation;
        }
        zoom.value = "${controller1.scale ?? 0}";
      }

      void syncController1() {
        if (controller1.scale != controller2.scale) {
          controller1.scale = controller2.scale;
        }
        if (controller1.position != controller2.position) {
          controller1.position = controller2.position;
        }
        if (controller1.rotation != controller2.rotation) {
          controller1.rotation = controller2.rotation;
        }
        zoom.value = "${controller1.scale ?? 0}";
      }

      void syncScaleState2() {
        if (scaleStateController2.scaleState !=
            scaleStateController1.scaleState) {
          scaleStateController2.scaleState = scaleStateController1.scaleState;
        }
        zoom.value = "${controller1.scale ?? 0}";
      }

      void syncScaleState1() {
        if (scaleStateController1.scaleState !=
            scaleStateController2.scaleState) {
          scaleStateController1.scaleState = scaleStateController2.scaleState;
        }
        zoom.value = "${controller1.scale ?? 0}";
      }

      controller1.addIgnorableListener(syncController2);
      controller2.addIgnorableListener(syncController1);
      scaleStateController1.addIgnorableListener(syncScaleState2);
      scaleStateController2.addIgnorableListener(syncScaleState1);

      return () {
        controller1.removeIgnorableListener(syncController2);
        controller2.removeIgnorableListener(syncController1);
        scaleStateController1.removeIgnorableListener(syncScaleState2);
        scaleStateController2.removeIgnorableListener(syncScaleState1);
      };
    }, [
      controller1,
      controller2,
      scaleStateController1,
      scaleStateController2
    ]);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceBright.withOpacity(.3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: asyncSimilarities.when(
        data: (data) {
          final item = data.elementAtOrNull(indexInPage);

          if (item == null) {
            return const SizedBox.shrink();
          }

          final image1 = item.image1.value;
          final image2 = item.image2.value;

          final entriesDontExist = image1 == null || image2 == null;

          if (entriesDontExist) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DeleteImageBtn(
                      image: image1,
                      itemCount: itemCount,
                    ),
                    FilterImageBtn(
                      image: image1,
                    ),
                    const Spacer(),
                    ToolbarBtn(
                      onTap: () {
                        controller1.scale =
                            ((controller1.scale ?? 0) - .1).clamp(0.1, 5.0);
                      },
                      icon: FluentIcons.zoom_out_24_regular,
                    ),
                    ToolbarBtn(
                      onTap: () {
                        controller1.scale =
                            ((controller1.scale ?? 0) + .1).clamp(0.1, 5.0);
                      },
                      icon: FluentIcons.zoom_in_24_regular,
                    ),
                    ToolbarBtn(
                      onTap: () {
                        if (scaleStateController1.scaleState ==
                            PhotoViewScaleState.originalSize) {
                          scaleStateController1.scaleState =
                              PhotoViewScaleState.initial;
                          return;
                        }
                        scaleStateController1.scaleState =
                            PhotoViewScaleState.originalSize;
                      },
                      icon: FluentIcons.zoom_fit_24_filled,
                    ),
                    ToolbarBtn(
                      onTap: () {
                        controller1.rotation =
                            (controller1.rotation - pi / 4).clamp(-pi, pi);
                      },
                      icon:
                          FluentIcons.arrow_rotate_counterclockwise_24_regular,
                    ),
                    ToolbarBtn(
                      onTap: () {
                        controller1.rotation =
                            (controller1.rotation + pi / 4).clamp(-pi, pi);
                      },
                      icon: FluentIcons.arrow_rotate_clockwise_24_regular,
                    ),
                    ToolbarBtn(
                      isSelected: viewMode.value == ImageViewMode.splitView,
                      selectedIcon: FluentIcons.image_split_24_filled,
                      icon: FluentIcons.image_split_24_regular,
                      onTap: () {
                        switch (viewMode.value) {
                          case ImageViewMode.splitView:
                            viewMode.value = ImageViewMode.sideBySide;
                            break;
                          default:
                            viewMode.value = ImageViewMode.splitView;
                            break;
                        }
                      },
                    ),
                    ToolbarBtn(
                      isSelected: viewMode.value == ImageViewMode.diffView,
                      selectedIcon: FluentIcons.image_multiple_24_filled,
                      icon: FluentIcons.image_multiple_24_regular,
                      onTap: () {
                        switch (viewMode.value) {
                          case ImageViewMode.diffView:
                            viewMode.value = ImageViewMode.sideBySide;
                            break;
                          default:
                            viewMode.value = ImageViewMode.diffView;
                            break;
                        }
                      },
                    ),
                    const Spacer(),
                    FilterImageBtn(
                      image: image2,
                    ),
                    DeleteImageBtn(
                      image: image2,
                      itemCount: itemCount,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Zoom: ${zoom.value}",
                      style: context.textTheme.bodySmall,
                    ),
                    Text(
                      "Rotation: ${controller1.rotation.toString()}",
                      style: context.textTheme.bodySmall,
                    ),
                    Text(
                      "Position: ${controller1.position.toString()}",
                      style: context.textTheme.bodySmall,
                    ),
                    Text(
                      "ScaleState: ${scaleStateController1.scaleState.name}",
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (() {
                  switch (viewMode.value) {
                    case ImageViewMode.diffView:
                      return DifferenceImageViewer(
                        similarity: item,
                        controller: controller1,
                        scaleStateController: scaleStateController1,
                      );
                    case ImageViewMode.splitView:
                      return BeforeAfter(
                        autofocus: true,
                        trackWidth: 2.0,
                        trackColor: context.colorScheme.outlineVariant,
                        thumbColor: context.colorScheme.outlineVariant,
                        value: splitPosition.value,
                        onValueChanged: (value) {
                          splitPosition.value = value;
                        },
                        before: SimilarPhotoView(
                          image: image1,
                          controller: controller1,
                          scaleStateController: scaleStateController1,
                        ),
                        after: SimilarPhotoView(
                          image: image2,
                          controller: controller2,
                          scaleStateController: scaleStateController2,
                        ),
                      );
                    default:
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: SimilarPhotoView(
                              image: image1,
                              controller: controller1,
                              scaleStateController: scaleStateController1,
                            ),
                          ),
                          Flexible(
                            child: SimilarPhotoView(
                              image: image2,
                              controller: controller2,
                              scaleStateController: scaleStateController2,
                            ),
                          ),
                        ],
                      );
                  }
                })(),
              ),
              SimilaritiesDetailsView(
                item: item,
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return AsyncErrorView(
            error: error,
            stackTrace: stackTrace,
          );
        },
        loading: () {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class DifferenceImageViewer extends HookConsumerWidget {
  const DifferenceImageViewer({
    super.key,
    required this.similarity,
    required this.controller,
    required this.scaleStateController,
  });
  final ImageSimilarity similarity;
  final PhotoViewController controller;
  final PhotoViewScaleStateController scaleStateController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDiffImage = ref.watch(differenceImageProvider(similarity));
    return asyncDiffImage.when(
      data: (data) {
        if (data == null) {
          return const Center(
            child: Icon(
              FluentIcons.image_off_24_filled,
              size: 24 * 3,
            ),
          );
        }

        return ImageView(
          image: MemoryImage(data),
          controller: controller,
          scaleStateController: scaleStateController,
        );
      },
      error: (error, stackTrace) {
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return Center(
          child: SizedBox(
            width: context.layout.width * .5,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      },
    );
  }
}

class FilterImageBtn extends ConsumerWidget {
  const FilterImageBtn({
    super.key,
    required this.image,
  });
  final ImageEntry image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pathFilters = ref.watch(pathFiltersProvider);
    return ToolbarBtn(
      isSelected: pathFilters.contains(image.imagePath),
      icon: FluentIcons.filter_24_regular,
      selectedIcon: FluentIcons.filter_dismiss_24_regular,
      onTap: () {
        ref.read(pathFiltersProvider.notifier).toggleFilter(image.imagePath);
      },
    );
  }
}

class DeleteImageBtn extends ConsumerWidget {
  const DeleteImageBtn({
    super.key,
    required this.image,
    required this.itemCount,
  });
  final int itemCount;
  final ImageEntry image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToolbarBtn(
      icon: FluentIcons.delete_24_regular,
      onTap: () async {
        if (!context.mounted) {
          return;
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Are you sure you want to delete ",
                          ),
                          TextSpan(
                              text: path.basename(image.imagePath),
                              style: context.textTheme.labelSmall),
                          const TextSpan(
                            text: "?\n",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: const EdgeInsets.all(
                        16.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            context.colorScheme.errorContainer.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "THIS ACTION IS IRREVERSIBLE",
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).maybePop(false);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).maybePop(true);
                          },
                          child: const Text("Continue"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (confirm != true) {
          return;
        }

        await ref
            .read(fileOpsControllerProvider.notifier)
            .deleteFile(image.imagePath);

        ref
            .read(selectedIndexProvider.notifier)
            .selectNextOrPrevious(itemCount);
        if (!context.mounted) {
          return;
        }
        context.showSnackBar(
          message: "${path.basename(image.imagePath)} has been deleted",
        );
      },
    );
  }
}

class ToolbarBtn extends HookConsumerWidget {
  const ToolbarBtn({
    super.key,
    required this.icon,
    this.onTap,
    this.isSelected,
    this.selectedIcon,
  });
  final VoidCallback? onTap;
  final IconData icon;
  final IconData? selectedIcon;
  final bool? isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      isSelected: isSelected,
      selectedIcon: selectedIcon == null
          ? null
          : Icon(
              selectedIcon,
              size: 20,
            ),
      icon: Icon(
        icon,
        size: 20,
      ),
    );
  }
}

class SimilarPhotoView extends HookConsumerWidget {
  const SimilarPhotoView({
    super.key,
    required this.image,
    required this.controller,
    required this.scaleStateController,
  });
  final ImageEntry image;
  final PhotoViewController controller;
  final PhotoViewScaleStateController scaleStateController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImageView(
      image: FileImage(
        File(image.imagePath),
      ),
      controller: controller,
      scaleStateController: scaleStateController,
    );
  }
}

class ImageView extends HookConsumerWidget {
  const ImageView({
    super.key,
    required this.image,
    required this.controller,
    required this.scaleStateController,
  });
  final ImageProvider<Object>? image;
  final PhotoViewController controller;
  final PhotoViewScaleStateController scaleStateController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: context.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: PhotoView(
        controller: controller,
        scaleStateController: scaleStateController,
        enablePanAlways: true,
        imageProvider: image,
        filterQuality: FilterQuality.high,
        backgroundDecoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer.withOpacity(.8),
        ),
        errorBuilder: (context, error, stackTrace) {
          if (error is PathNotFoundException) {
            return const Center(
              child: Icon(
                FluentIcons.image_off_24_filled,
                size: 24 * 3,
              ),
            );
          }
          return AsyncErrorView(
            error: error,
            stackTrace: stackTrace,
          );
        },
      ),
    );
  }
}
