import 'dart:io';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/scan_loader.dart';
import 'package:looks_like_it/components/similarity_indicator.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';

import 'package:looks_like_it/utils/extensions.dart';
import 'package:path/path.dart' as path;

class SimilarityListTile extends StatelessWidget {
  const SimilarityListTile({
    super.key,
    required this.onTap,
    required this.item,
    this.selected = false,
  });

  final VoidCallback onTap;
  final bool selected;
  final ImageSimilarity item;

  @override
  Widget build(BuildContext context) {
    final size = context.layout.value(
      xs: 50,
      sm: context.layout.width < 900 ? 60 : 36,
    );
    final textStyle = context.textTheme.labelSmall;
    final image1 = item.image1.value;
    final image2 = item.image2.value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          color: selected ? context.colorScheme.surfaceContainerHigh : null,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: context.layout.value(
            xs: MainAxisAlignment.start,
            sm: context.layout.width < 900
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.start,
          ),
          children: [
            Container(
              // width: size.toDouble(),
              // height: size.toDouble(),
              constraints: BoxConstraints(
                maxHeight: size.toDouble(),
                maxWidth: size.toDouble(),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: image1 == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover,
                        image: ResizeImage(
                          FileImage(
                            File(image1.imagePath),
                          ),
                          width: size,
                          height: size,
                        ),
                      ),
              ),
            ),
            ...context.layout.value(
              xs: [],
              sm: context.layout.width < 900
                  ? []
                  : [
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              path.basenameWithoutExtension(
                                  image1?.imagePath ?? "no image"),
                              maxLines: 1,
                              style: textStyle,
                            ),
                            Text(
                              path.basenameWithoutExtension(
                                  image2?.imagePath ?? "no image"),
                              maxLines: 1,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
            ),
            const SizedBox(
              width: 8.0,
            ),
            SimilarityIndicator(
              similarity: item.similarity,
            ),
          ],
        ),
      ),
    );
  }
}

class SimilarityListTileLoading extends StatelessWidget {
  const SimilarityListTileLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.layout.value(
      xs: 50,
      sm: context.layout.width < 900 ? 60 : 36,
    );
    final textStyle = context.textTheme.labelSmall;
    final color = context.colorScheme.surfaceContainerHigh;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: context.layout.value(
          xs: MainAxisAlignment.start,
          sm: context.layout.width < 900
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.start,
        ),
        children: [
          Shimmered(
            width: size.toDouble(),
            height: size.toDouble(),
            color: color,
          ),
          ...context.layout.value(
            xs: [],
            sm: context.layout.width < 900
                ? []
                : [
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Shimmered(
                            width: 100,
                            height: textStyle?.fontSize,
                            borderRadius: 500.0,
                            color: color,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Shimmered(
                            width: 100,
                            height: textStyle?.fontSize,
                            borderRadius: 500.0,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ],
          ),
          const SizedBox(
            width: 8.0,
          ),
          Shimmered(
            width: 24,
            height: 24,
            borderRadius: 500.0,
            color: color,
          ),
        ],
      ),
    );
  }
}
