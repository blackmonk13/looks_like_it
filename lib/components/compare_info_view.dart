import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/image_info_view.dart';
import 'package:looks_like_it/models/similar_image.dart';
import 'package:looks_like_it/providers/common.dart';

class CompareInfoView extends ConsumerWidget {
  const CompareInfoView({
    super.key,
    required this.data,
  });

  final SimilarImage data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedSimilarityProvider);
    final similarities = data.similarities;
    return Row(
      children: [
        Flexible(
          child: Builder(
            builder: (context) {
              final item = data;

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
              final item =
                  similarities.elementAt(selectedId);

              return ImageInfoView(
                image: item,
              );
            },
          ),
        ),
      ],
    );
    // return ValueListenableBuilder(
    //   valueListenable: Hive.box<SimilarImage>('similarities').listenable(),
    //   builder: (context, Box<SimilarImage> box, _) {
    //     return Row(
    //       children: [
    //         Flexible(
    //           child: Builder(
    //             builder: (context) {
    //               final item = data;

    //               return ImageInfoView(
    //                 image: item,
    //               );
    //             },
    //           ),
    //         ),
    //         const VerticalDivider(
    //           width: 2.0,
    //         ),
    //         Flexible(
    //           child: Builder(
    //             builder: (context) {
    //               final item = box.getAt(selectedGroup.selectedSimilarity);

    //               if (item == null) {
    //                 return const SizedBox.shrink();
    //               }
    //               return ImageInfoView(
    //                 image: item,
    //               );
    //             },
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
