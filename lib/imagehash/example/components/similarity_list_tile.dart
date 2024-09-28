import 'dart:io';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/imagehash/example/components/similarity_indicator.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        decoration: BoxDecoration(
          color: selected ? context.colorScheme.surfaceContainerHigh : null,
          borderRadius: BorderRadius.circular(10.0),
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
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: ResizeImage(
                    FileImage(
                      File(item.image1Path),
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
                              path.basenameWithoutExtension(item.image1Path),
                              maxLines: 1,
                              style: textStyle,
                            ),
                            Text(
                              path.basenameWithoutExtension(item.image2Path),
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
