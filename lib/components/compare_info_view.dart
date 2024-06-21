import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/image_info_view.dart';
import 'package:looks_like_it/models/similar_image/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';

class CompareInfoView extends ConsumerWidget {
  const CompareInfoView({
    super.key,
    required this.data,
  });

  final ({SimilarImage image, List<SimilarImage> similarities}) data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectionGroupProvider);
    return Row(
      children: [
        Flexible(
          child: Builder(
            builder: (context) {
              final item = data.image;

              return ImageInfoView(
                image: item,
              );
            },
          ),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        Flexible(
          child: Builder(
            builder: (context) {
              if (data.similarities.isEmpty) {
                return const SizedBox.shrink();
              }

              final item = data.similarities.elementAt(
                selectedGroup.selectedSimilarity,
              );

              return ImageInfoView(
                image: item,
              );
            },
          ),
        ),
      ],
    );
  }
}
