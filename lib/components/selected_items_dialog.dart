import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/selected_images_photo_view_gallery.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SelectedItemsDialog extends HookConsumerWidget {
  const SelectedItemsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);

    useEffect(() {
      if (selectedImages.isEmpty) {
        Navigator.of(context).maybePop();
      }
      return null;
    }, [selectedImages]);

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainer,
      surfaceTintColor: context.colorScheme.surfaceContainer,
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: AspectRatio(
        aspectRatio: context.screenAspect,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              backgroundColor: context.colorScheme.surfaceContainer,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(FluentIcons.arrow_left_24_regular),
              ),
              title: Text.rich(
                TextSpan(
                  text: "All",
                  children: [
                    const TextSpan(text: "\n"),
                    TextSpan(
                        text: selectedImages.length.toString(),
                        style: context.textTheme.labelSmall,
                        children: [
                          const TextSpan(text: " item"),
                          TextSpan(text: selectedImages.length == 1 ? "" : "s"),
                        ]),
                  ],
                ),
              ),
              actions: const [],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Divider(
                  height: 1.0,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverFillRemaining(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final image = selectedImages.elementAt(index);
                    final imagePath = image.imagePath;
                    return InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return SelectedImagesPhotoViewGallery(
                              initialPage: index,
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: context.colorScheme.surfaceContainerHigh,
                          // border: selected
                          //     ? Border.all(
                          //         color: Theme.of(context).colorScheme.primary,
                          //         width: 3.0,
                          //       )
                          //     : null,
                          // image: imagePath == null
                          //     ? null
                          //     : DecorationImage(
                          //         fit: BoxFit.cover,
                          //         filterQuality: FilterQuality.medium,
                          //         image: ResizeImage(
                          //           width: 256,
                          //           height: 256,
                          //           policy: ResizeImagePolicy.fit,
                          //           ref.read(fileImageProvider(imagePath)),
                          //         ),
                          //       ),
                        ),
                        child: Hero(
                          tag: image.imageHash,
                          child: Image(
                            image: ResizeImage(
                              width: 256,
                              height: 256,
                              policy: ResizeImagePolicy.fit,
                              ref.read(fileImageProvider(imagePath)),
                            ),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
