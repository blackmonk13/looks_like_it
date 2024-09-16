import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/selected_items_dialog.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SelectedImagesText extends ConsumerWidget {
  const SelectedImagesText({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(selectedImagesProvider);

    if (selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return const SelectedItemsDialog();
            },
          );
        },
        child: Text(
          "${selectedImages.length} Selected",
          style: context.textTheme.labelMedium,
        ),
      ),
    );
  }
}
