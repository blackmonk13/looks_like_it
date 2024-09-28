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
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart' as path;

class SimilaritiesPhotoViews extends HookConsumerWidget {
  const SimilaritiesPhotoViews({
    super.key,
    required this.item,
  });
  final ImageSimilarity item;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller1 = usePhotoViewController();
    final controller2 = usePhotoViewController();
    final scaleStateController1 = usePhotoViewScaleStateController();
    final scaleStateController2 = usePhotoViewScaleStateController();

    final splitView = useState(false);
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
        print("Sync 2 called");
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
        print("Sync 1 called");
        zoom.value = "${controller1.scale ?? 0}";
      }

      void syncScaleState2() {
        if (scaleStateController2.scaleState !=
            scaleStateController1.scaleState) {
          scaleStateController2.scaleState = scaleStateController1.scaleState;
        }
        print("Sync scale 2 called");
        zoom.value = "${controller1.scale ?? 0}";
      }

      void syncScaleState1() {
        if (scaleStateController1.scaleState !=
            scaleStateController2.scaleState) {
          scaleStateController1.scaleState = scaleStateController2.scaleState;
        }
        print("Sync scale 1 called");
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
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DeleteImageBtn(imagePath: item.image1Path),
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
                  icon: FluentIcons.arrow_rotate_counterclockwise_24_regular,
                ),
                ToolbarBtn(
                  onTap: () {
                    controller1.rotation =
                        (controller1.rotation + pi / 4).clamp(-pi, pi);
                  },
                  icon: FluentIcons.arrow_rotate_clockwise_24_regular,
                ),
                ToolbarBtn(
                  isSelected: splitView.value,
                  selectedIcon: FluentIcons.image_split_24_filled,
                  icon: FluentIcons.image_split_24_regular,
                  onTap: () => splitView.value = !splitView.value,
                ),
                const Spacer(),
                DeleteImageBtn(imagePath: item.image2Path),
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
            child: IndexedStack(
              index: splitView.value ? 1 : 0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: SimilarPhotoView(
                        imagePath: item.image1Path,
                        controller: controller1,
                        scaleStateController: scaleStateController1,
                      ),
                    ),
                    Flexible(
                      child: SimilarPhotoView(
                        imagePath: item.image2Path,
                        controller: controller2,
                        scaleStateController: scaleStateController2,
                      ),
                    ),
                  ],
                ),
                BeforeAfter(
                  autofocus: true,
                  trackWidth: 2.0,
                  trackColor: context.colorScheme.outlineVariant,
                  thumbColor: context.colorScheme.outlineVariant,
                  value: splitPosition.value,
                  onValueChanged: (value) {
                    splitPosition.value = value;
                  },
                  before: SimilarPhotoView(
                    imagePath: item.image1Path,
                    controller: controller1,
                    scaleStateController: scaleStateController1,
                  ),
                  after: SimilarPhotoView(
                    imagePath: item.image2Path,
                    controller: controller2,
                    scaleStateController: scaleStateController2,
                  ),
                ),
              ],
            ),
          ),
          SimilaritiesDetailsView(item: item),
        ],
      ),
    );
  }
}

class DeleteImageBtn extends StatelessWidget {
  const DeleteImageBtn({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ToolbarBtn(
      icon: FluentIcons.delete_24_regular,
      onTap: () async {
        if (!context.mounted) {
          return;
        }
        final imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          context.showErrorSnackBar(
            message:
                "${imageFile.path} does not exist or has already been deleted",
          );
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
                              text: path.basename(imageFile.path),
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

        final deleted = await imageFile.delete();
        if (await deleted.exists()) {
          context.showErrorSnackBar(
            message: "Error deleting ${imageFile.path}",
          );
          return;
        }

        context.showSnackBar(message: "${imageFile.path} has been deleted");
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
    required this.imagePath,
    required this.controller,
    required this.scaleStateController,
  });
  final String imagePath;
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
        imageProvider: FileImage(
          File(imagePath),
        ),
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
