import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/groups_view.dart';
import 'package:looks_like_it/components/image_info_view.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'delete_btn.dart';

class SelectedImagesPhotoViewGallery extends HookConsumerWidget {
  const SelectedImagesPhotoViewGallery({
    super.key,
    this.initialPage = 0,
  });

  final int initialPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);
    final controller = usePageController(initialPage: initialPage);

    final currentPage = useState<int>(initialPage);
    final showInfo = useState<bool>(false);

    useEffect(() {
      if (selectedImages.isEmpty) {
        Navigator.of(context).maybePop();
      }
      if (currentPage.value > selectedImages.length - 1) {
        currentPage.value = selectedImages.length - 1;
      }
      return null;
    }, [selectedImages, currentPage.value]);

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainer,
      surfaceTintColor: context.colorScheme.surfaceContainer,
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () async {
            await controller.previousPage(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOutExpo,
            );
          },
          const SingleActivator(LogicalKeyboardKey.arrowRight): () async {
            await controller.nextPage(
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOutExpo,
            );
          },
        },
        child: Focus(
          autofocus: true,
          child: AspectRatio(
            aspectRatio: context.screenAspect,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 50.0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                        icon: const Icon(FluentIcons.arrow_left_24_regular),
                      ),
                      if (selectedImages.isNotEmpty)
                        Text(
                          p.basename(selectedImages
                              .elementAt(currentPage.value)
                              .imagePath),
                          style: context.textTheme.labelMedium,
                        ),
                      Text(
                        "${context.layout.breakpoint.toString()} ${context.layout.width}",
                      ),
                      const Spacer(),
                      DeleteBtn(
                        image: selectedImages.elementAt(currentPage.value),
                      ),
                      IconButton(
                        onPressed: () {
                          showInfo.value = !showInfo.value;
                        },
                        icon: const Icon(FluentIcons.info_24_regular),
                      ),
                      if (selectedImages.isNotEmpty)
                        SelectImageCheckBox(
                          image: selectedImages.elementAt(
                            currentPage.value,
                          ),
                        )
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
                Expanded(
                  flex: context.screenAspect.compareTo(1) == -1 ? 3 : 1,
                  child: Row(
                    children: [
                      if (currentPage.value > 0)
                        InkWell(
                          onTap: () async {
                            await controller.previousPage(
                              duration: const Duration(
                                milliseconds: 300,
                              ),
                              curve: Curves.easeInOutExpo,
                            );
                          },
                          child: Container(
                            width: 48.0,
                            height: context.shortestSide,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceContainer,
                            ),
                            child: Icon(
                              FluentIcons.chevron_left_24_filled,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      Expanded(
                        flex: context.layout.value(
                          xs: 1,
                          sm: 3,
                        ),
                        child: PhotoViewGallery.builder(
                          enableRotation: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          pageController: controller,
                          onPageChanged: (index) {
                            currentPage.value = index;
                          },
                          backgroundDecoration: BoxDecoration(
                            color: context.colorScheme.surfaceContainer,
                          ),
                          builder: (BuildContext context, int index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: ref.read(fileImageProvider(
                                  selectedImages[index].imagePath)),
                              initialScale:
                                  PhotoViewComputedScale.contained * 0.8,
                              heroAttributes: PhotoViewHeroAttributes(
                                tag: selectedImages[index].imageHash,
                              ),
                            );
                          },
                          itemCount: selectedImages.length,
                          loadingBuilder: (context, event) => Center(
                            child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (currentPage.value < selectedImages.length - 1)
                        InkWell(
                          onTap: () async {
                            await controller.nextPage(
                              duration: const Duration(
                                milliseconds: 300,
                              ),
                              curve: Curves.easeInOutExpo,
                            );
                          },
                          child: Container(
                            width: 48.0,
                            height: context.shortestSide,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surfaceContainer,
                            ),
                            child: Icon(
                              FluentIcons.chevron_right_24_filled,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      if (context.screenAspect.compareTo(1) >= 0) ...[
                        if (showInfo.value)
                          const VerticalDivider(
                            width: 2.0,
                          ),
                        Flexible(
                          flex: showInfo.value ? 1 : 0,
                          child: showInfo.value
                              ? ImageInfoView(
                                  image: selectedImages
                                      .elementAt(currentPage.value),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ]
                    ],
                  ),
                ),
                if (context.screenAspect.compareTo(1) == -1) ...[
                  if (showInfo.value)
                    const Divider(
                      height: 2.0,
                    ),
                  Flexible(
                    flex: showInfo.value ? 1 : 0,
                    child: showInfo.value
                        ? ImageInfoView(
                            image: selectedImages.elementAt(currentPage.value),
                          )
                        : const SizedBox.shrink(),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
