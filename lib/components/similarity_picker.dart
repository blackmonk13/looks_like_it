import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
import 'package:looks_like_it/providers/common.dart';
import 'package:looks_like_it/utils/utils.dart';
import 'package:looks_like_it/utils/extensions.dart';

class SimilarityPicker extends HookConsumerWidget {
  const SimilarityPicker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarity = ref.watch(similarityThresholdProvider);
    final textStyle = context.textTheme.labelSmall;

    return IconButton(
      onPressed: () async {
        double updated = similarity;
        await showDialog(
          context: context,
          builder: (context) {
            return SimilaritySliderDialog(
              initialValue: similarity,
              onChanged: (value) {
                updated = value;
              },
            );
          },
        );

        if (updated == similarity) {
          return;
        }

        ref.read(similarityThresholdProvider.notifier).setThreshold(updated);
        ref.invalidate(selectedIndexProvider);
      },
      icon: SizedBox.square(
        dimension: 48,
        child: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  "${similarity.round()}%",
                  style: textStyle?.copyWith(
                    fontSize: textStyle.fontSize == null
                        ? null
                        : textStyle.fontSize! * 1.2,
                    // color: colorForPercentage(similarity),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned.fill(
              child: CircularProgressIndicator(
                value: similarity / 100,
                strokeWidth: 4.0,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation(
                  colorForPercentage(similarity),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimilaritySliderDialog extends HookConsumerWidget {
  const SimilaritySliderDialog({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  final double initialValue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarityRatio = useState<double>(initialValue);
    return Dialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: context.colorScheme.surfaceContainerHigh,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        width: context.layout.value(
          xs: context.screenWidth * .8,
          sm: 600.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "Similarity",
                style: context.textTheme.headlineSmall,
              ),
              trailing: Text("${similarityRatio.value.round()}%"),
            ),
            Slider(
              value: similarityRatio.value,
              min: 1.0,
              max: 100.0,
              label: "${similarityRatio.value.round()}%",
              divisions: 99,
              autofocus: true,
              activeColor: colorForPercentage(similarityRatio.value),
              onChanged: (value) {
                similarityRatio.value = value;
                onChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
