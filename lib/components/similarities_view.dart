import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/groups_view.dart';
import 'package:looks_like_it/models/similar_image/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as p;

class SimilaritiesView extends HookConsumerWidget {
  final Map<SimilarImage, List<SimilarImage>> data;
  const SimilaritiesView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectionGroupProvider);
    return Row(
      children: [
        Flexible(
          child: Container(
            color: context.colorScheme.surfaceContainer,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 0.4,
                  height: 2.0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final item = data.keys.elementAt(index);
            
                final similarities = data.values.elementAt(index);
                final selected = selectedGroup.selectedImage == index;
                return SimilarityTile(
                  onTap: () {
                    ref.read(selectionGroupProvider.notifier).selectImage(index);
                  },
                  selected: selected,
                  image: item,
                  similarities: similarities,
                );
              },
            ),
          ),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        Flexible(
          flex: 4,
          child: GroupsView(
            data: (
              image: data.keys.elementAt(selectedGroup.selectedImage),
              similarities: data.values.elementAt(selectedGroup.selectedImage),
            ),
          ),
        ),
      ],
    );
  }
}

class SimilarityTile extends ConsumerWidget {
  const SimilarityTile({
    super.key,
    required this.image,
    required this.similarities,
    this.selected = false,
    this.onTap,
  });

  final SimilarImage image;
  final List<SimilarImage> similarities;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = image.imagePath;
    const size = 50.0;
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      selected: selected,
      selectedTileColor: context.colorScheme.surfaceContainerLow,
      onTap: onTap,
      leading: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: imagePath == null
              ? null
              : DecorationImage(
                  fit: BoxFit.cover,
                  image: ResizeImage(
                    width: size.toInt(),
                    height: size.toInt(),
                    policy: ResizeImagePolicy.fit,
                    ref.read(fileImageProvider(imagePath)),
                  ),
                ),
        ),
      ),
      title: Text(
        imagePath == null ? "Unknown" : p.basename(imagePath),
        style: context.textTheme.labelMedium,
        softWrap: true,
        maxLines: 1,
      ),
      trailing: Card.outlined(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 8.0,
          ),
          child: Text(
            "${similarities.length}",
            style: context.textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}
