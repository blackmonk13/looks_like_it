import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/data/similarities_repository.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as p;

class DeleteBtn extends ConsumerWidget {
  const DeleteBtn({
    super.key,
    required this.image,
  });

  final SimilarImage image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDelete = ref.watch(deleteImageProvider(image));

    return asyncDelete.when(
      data: (deleted) {
        return IconButton(
          onPressed: () async {
            final selectedImage = image;

            final isKey = selectedImage.similarities.isNotEmpty;

            final imageName = p.basename(selectedImage.imagePath);

            // final prevIndex = itemIndex == null
            //     ? 0
            //     : itemIndex > 0
            //         ? itemIndex - 1
            //         : null;

            // final nextIndex = itemIndex == null
            //     ? 0
            //     : itemIndex < box.length - 1
            //         ? itemIndex + 1
            //         : null;

            await ref.read(deleteImageProvider(image).notifier).delete();

            if (!deleted) {
              if (context.mounted) {
                context.showErrorSnackBar(
                  message: "Error deleting $imageName",
                );
              }
              return;
            }

            ref.read(selectedImagesProvider.notifier).deselect(selectedImage);

            ref.invalidate(fileImageProvider(selectedImage.imagePath));
            // if ([nextIndex, prevIndex].any((e) => e != null)) {
            //   final goTo = nextIndex ?? prevIndex ?? 0;
            //   if (isKey) {
            //     ref
            //         .read(selectionGroupProvider.notifier)
            //         .selectImage(goTo);
            //   } else {
            //     ref
            //         .read(selectionGroupProvider.notifier)
            //         .selectSimilarity(goTo);
            //   }
            // } else {
            if (isKey) {
              ref.invalidate(selectedIdProvider);
              ref.invalidate(selectedSimilarityProvider);
            } else {
              ref.invalidate(selectedSimilarityProvider);
            }
            // }

            if (context.mounted) {
              context.showSnackBar(
                message: "$imageName has been deleted.",
              );
            }
          },
          icon: const Icon(FluentIcons.delete_24_regular),
        );
      },
      error: (error, stackTrace) {
        return IconButton(
          onPressed: () {
            ref.invalidate(deleteImageProvider(image));
          },
          icon: const Icon(FluentIcons.warning_24_regular),
        );
      },
      loading: () {
        return const CircularProgressIndicator(
          strokeWidth: 2.0,
        );
      },
    );
  }
}
