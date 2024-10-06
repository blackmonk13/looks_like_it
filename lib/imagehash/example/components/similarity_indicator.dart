import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:looks_like_it/imagehash/example/utils.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilarityIndicator extends StatelessWidget {
  const SimilarityIndicator({
    super.key,
    required this.similarity,
  });

  final double similarity;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme.labelSmall;
    return SizedBox.square(
      dimension: 28.0,
      child: similarity.compareTo(100.0) >= 0
          ? Icon(
              FluentIcons.checkmark_circle_24_filled,
              color: colorForPercentage(similarity),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      value: similarity / 100,
                      strokeWidth: 2.0,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation(
                        colorForPercentage(similarity),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      "${similarity.round()}",
                      style: textTheme?.copyWith(
                        color: colorForPercentage(similarity),
                        fontWeight: FontWeight.w800,
                        fontSize: textTheme.fontSize == null
                            ? null
                            : textTheme.fontSize! / 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
