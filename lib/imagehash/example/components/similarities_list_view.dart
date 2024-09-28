import 'package:flutter/material.dart';
import 'package:looks_like_it/imagehash/example/components/similarity_list_tile.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilaritiesListView extends StatelessWidget {
  const SimilaritiesListView({
    super.key,
    required this.data,
    required this.selectedIndex,
  });
  final List<ImageSimilarity> data;
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelSmall;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Row(
            children: <Widget>[
              Text(
                "${data.length.toString()} Pairs",
                style: textStyle?.copyWith(
                  color: textStyle.color?.withOpacity(.4),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: .5,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: .5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final item = data.elementAt(index);
              return SimilarityListTile(
                selected: selectedIndex.value == index,
                item: item,
                onTap: () {
                  selectedIndex.value = index;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
