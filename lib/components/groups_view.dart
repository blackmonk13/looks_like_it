import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/compare_info_view.dart';
import 'package:looks_like_it/components/delete_btn.dart';
import 'package:looks_like_it/components/image_similarities_view.dart';
import 'package:looks_like_it/data/similarities_repository.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';

import 'package:looks_like_it/components/image_compare_view.dart';

class GroupsView extends HookConsumerWidget {
  const GroupsView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedImagesProvider);
    final selectedId = ref.watch(selectedSimilarityProvider);
    final asyncImage = ref.watch(selectedImageProvider);
    final showInfo = useState<bool>(true);

    return asyncImage.when(
      data: (data) {
        if (data == null) {
          return Container(
            color: context.colorScheme.surfaceContainer,
          );
        }
        final similarities = data.similarities;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SelectImageCheckBox(
                            image: data,
                          ),
                          DeleteBtn(
                            image: data,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FluentIcons.full_screen_maximize_24_regular,
                            ),
                          ),
                          const ImageViewModeBtn(),
                          IconButton(
                            onPressed: () {
                              showInfo.value = !showInfo.value;
                            },
                            icon: const Icon(FluentIcons.info_24_regular),
                          ),
                          const Spacer(),
                          DeleteBtn(
                            image: similarities.elementAt(selectedId),
                          ),
                          SelectImageCheckBox(
                            image: similarities.elementAt(selectedId),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2.0,
                    ),
                    Flexible(
                      flex: 11,
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
                    if (showInfo.value)
                      Flexible(
                        flex: 3,
                        child: CompareInfoView(
                          data: data,
                        ),
                      ),
                    Flexible(
                      flex: context.layout.value(xs: 3, md: 0),
                      child: AdaptiveBuilder(
                        xs: (context) {
                          return const ImageSimilaritiesView(
                            horizontal: true,
                          );
                        },
                        md: (context) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
    // return ValueListenableBuilder(
    //   valueListenable: Hive.box<SimilarImage>('similarities').listenable(),
    //   builder: (context, Box<SimilarImage> box, _) {

    //     final data = box.getAt(selectedGroup.selectedImage);

    //     if (data == null) {
    //       return const SizedBox.shrink();
    //     }

    //     final similarities = data.similarities;

    //     return Container(
    //       color: context.colorScheme.surfaceContainer,
    //       // width: MediaQuery.of(context).size.width,
    //       child: Row(
    //         children: [
    //           Flexible(
    //             flex: 7,
    //             child: Column(
    //               children: [
    //                 Flexible(
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SelectImageCheckBox(
    //                         image: data,
    //                       ),
    //                       const Spacer(),
    //                       IconButton(
    //                         onPressed: () {},
    //                         icon: const Icon(
    //                           FluentIcons.full_screen_maximize_24_regular,
    //                         ),
    //                       ),
    //                       const ImageViewModeBtn(),
    //                       const Spacer(),
    //                       if (similarities != null)
    //                         SelectImageCheckBox(
    //                           image: box.getAt(selectedGroup.selectedSimilarity)
    //                               as SimilarImage,
    //                         ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   height: 2.0,
    //                 ),
    //                 Flexible(
    //                   flex: 11,
    //                   child: Stack(
    //                     alignment: Alignment.center,
    //                     children: [
    //                       Positioned.fill(
    //                         child: ImageCompareView(
    //                           data: data,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Divider(
    //                   height: 2.0,
    //                 ),
    //                 Flexible(
    //                   flex: 3,
    //                   child: CompareInfoView(
    //                     data: data,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const VerticalDivider(
    //             width: 2.0,
    //           ),
    //           if (similarities != null)
    //             Flexible(
    //               child: Column(
    //                 children: [
    //                   Flexible(
    //                     child: Container(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 8.0,
    //                         vertical: 4.0,
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           // SelectSimilaritiesCheckBox(
    //                           //   similarities: similarities as List<SimilarImage>,
    //                           // ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   const Divider(
    //                     height: 1.0,
    //                   ),
    //                   Expanded(
    //                     flex: 13,
    //                     child: ListView.separated(
    //                       padding: const EdgeInsets.symmetric(
    //                         vertical: 16.0,
    //                         horizontal: 16.0,
    //                       ),
    //                       // shrinkWrap: true,
    //                       itemCount: similarities.length,
    //                       separatorBuilder: (BuildContext context, int index) {
    //                         return const Divider();
    //                       },
    //                       itemBuilder: (BuildContext context, int index) {
    //                         final item =
    //                             similarities.elementAt(index) as SimilarImage;

    //                         final imagePath = item.imagePath;
    //                         final selected =
    //                             selectedGroup.selectedSimilarity == item.key;
    //                         return GestureDetector(
    //                           onTap: () {
    //                             ref
    //                                 .read(selectionGroupProvider.notifier)
    //                                 .selectSimilarity(item.key as int);
    //                           },
    //                           child: AspectRatio(
    //                             aspectRatio: 1,
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                 borderRadius: BorderRadius.circular(5.0),
    //                                 color: context
    //                                     .colorScheme.surfaceContainerHigh,
    //                                 border: selected
    //                                     ? Border(
    //                                         left: BorderSide(
    //                                           color: Theme.of(context)
    //                                               .colorScheme
    //                                               .primary,
    //                                           width: 5.0,
    //                                         ),
    //                                       )
    //                                     : null,
    //                                 image: DecorationImage(
    //                                   fit: BoxFit.cover,
    //                                   image: ResizeImage(
    //                                     width: 95,
    //                                     height: 95,
    //                                     policy: ResizeImagePolicy.fit,
    //                                     ref.read(fileImageProvider(imagePath)),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}

class SelectImageCheckBox extends HookConsumerWidget {
  const SelectImageCheckBox({
    super.key,
    required this.image,
  });

  final SimilarImage image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);

    final selected = useState<bool>(false);

    useEffect(() {
      selected.value = selectedImages.contains(image);
      return null;
    }, [image, selectedImages]);

    return Checkbox(
      value: selected.value,
      checkColor: context.colorScheme.surface,
      activeColor: context.colorScheme.onSurface,
      side: BorderSide(
        color: context.colorScheme.outlineVariant,
      ),
      onChanged: (value) {
        if (value == null) {
          return;
        }

        selected.value = value;

        if (value) {
          return ref.read(selectedImagesProvider.notifier).select(image);
        }
        ref.read(selectedImagesProvider.notifier).deselect(image);
      },
    );
  }
}

class SelectSimilaritiesCheckBox extends HookConsumerWidget {
  const SelectSimilaritiesCheckBox({
    super.key,
    required this.similarities,
  });

  final List<SimilarImage> similarities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);
    final hasEvery = similarities.every(selectedImages.contains);
    final hasAny = similarities.any(selectedImages.contains);

    final selected = useState<bool?>(null);

    useEffect(() {
      // Every item is present
      if (hasEvery) {
        selected.value = true;
      } else if (hasAny) {
        selected.value = null;
      } else {
        selected.value = false;
      }

      return null;
    }, [similarities, selectedImages]);

    return Checkbox(
      value: selected.value,
      tristate: true,
      checkColor: context.colorScheme.surface,
      activeColor: context.colorScheme.onSurface,
      side: BorderSide(
        color: context.colorScheme.outlineVariant,
      ),
      onChanged: (value) {
        selected.value = value;
        if (value == null) {
          if (hasEvery) {
            ref
                .read(selectedImagesProvider.notifier)
                .deselectMany(similarities);
          } else if (hasAny) {
            ref
                .read(selectedImagesProvider.notifier)
                .deselectMany(similarities);
          } else {
            ref.read(selectedImagesProvider.notifier).selectMany(similarities);
          }
        } else if (value) {
          ref.read(selectedImagesProvider.notifier).selectMany(similarities);
        } else {
          ref.read(selectedImagesProvider.notifier).deselectMany(similarities);
        }
      },
    );
  }
}
