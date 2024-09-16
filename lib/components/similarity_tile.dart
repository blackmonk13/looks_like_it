import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/scan_loader.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/constants.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as p;

class SimilarityTile extends HookConsumerWidget {
  const SimilarityTile({
    super.key,
    this.image,
    this.selected = false,
    this.error,
    this.loading = false,
    this.onTap,
  });

  final SimilarImage? image;
  final GestureTapCallback? onTap;
  final bool selected;
  final ({Object error, StackTrace stackTrace})? error;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = image?.imagePath;
    final size = context.layout.value(
      xs: context.layout.width * 0.125,
      md: 50.0,
    );

    const padding = EdgeInsets.symmetric(
      vertical: 2.0,
      horizontal: 2.0,
    );

    final color = selected
        ? context.colorScheme.surfaceContainerHigh
        : context.colorScheme.surfaceContainer;

    final boxConstraints = BoxConstraints(
      maxWidth: context.shortestSide,
      maxHeight: context.layout.value(
        xs: context.shortestSide,
        md: 60.0,
      ),
    );

    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: color,
    );

    useEffect(() {
      if (image == null) {
        return null;
      }

      if (!selected) {
        return null;
      }

      Future(() {
        ref.read(selectedIdProvider.notifier).selectId(image!.id);
        ref.read(selectedSimilarityProvider.notifier).selectId(0);
      });

      return null;
    }, [selected]);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        clipBehavior: Clip.hardEdge,
        padding: padding,
        decoration: boxDecoration,
        constraints: boxConstraints,
        child: AdaptiveBuilder(
          xs: (context) {
            if (loading) {
              return AspectRatio(
                aspectRatio: context.screenAspect,
                child: Shimmered(
                  color: context.colorScheme.surfaceContainerHigh,
                ),
              );
            }
            return AspectRatio(
              aspectRatio: context.screenAspect,
              child: error == null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: imagePath == null
                              ? const SizedBox.shrink()
                              : Image(
                                  fit: BoxFit.cover,
                                  image: ResizeImage(
                                    width: size.toInt(),
                                    height: size.toInt(),
                                    policy: ResizeImagePolicy.fit,
                                    ref.read(fileImageProvider(imagePath)),
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Card.outlined(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "${image?.similarities.length}",
                                style: context.textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Card.outlined(
                        //     elevation: 0,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //         vertical: 2.0,
                        //         horizontal: 8.0,
                        //       ),
                        //       child: Text(
                        //         "${size}",
                        //         style: context.textTheme.labelSmall,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  : Icon(
                      FluentIcons.warning_24_regular,
                      size: size,
                    ),
            );
          },
          md: (context) {
            return Row(
              children: [
                loading
                    ? Shimmered(
                        width: size,
                        height: size,
                        borderRadius: 5.0,
                        color: context.colorScheme.surfaceContainerHigh,
                      )
                    : Container(
                        width: size,
                        height: size,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: error == null
                            ? imagePath == null
                                ? null
                                : Image(
                                    fit: BoxFit.cover,
                                    image: ResizeImage(
                                      width: size.toInt(),
                                      height: size.toInt(),
                                      policy: ResizeImagePolicy.fit,
                                      ref.read(fileImageProvider(imagePath)),
                                    ),
                                  )
                            : Icon(
                                FluentIcons.warning_24_regular,
                                size: size * .7,
                              ),
                      ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: loading
                      ? Shimmered(
                          height: 14.0,
                          color: context.colorScheme.surfaceContainerHigh,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (error == null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Card.outlined(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                        horizontal: 8.0,
                                      ),
                                      child: Text(
                                        "${image?.similarities.length}",
                                        style: context.textTheme.labelSmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              error == null
                                  ? imagePath == null
                                      ? "Unknown"
                                      : p.basename(imagePath)
                                  : error?.error.toString() ?? "Error",
                              style: context.textTheme.labelMedium,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                ),
                if (selected)
                  Container(
                    width: 3.0,
                    color: context.colorScheme.primary,
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
