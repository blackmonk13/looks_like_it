import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/components/common/error_view.dart';
import 'package:looks_like_it/imagehash/example/providers.dart';
import 'package:looks_like_it/imagehash/imagehash.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:looks_like_it/utils/functions.dart';
import 'package:path/path.dart' as path;

class SimilaritiesDetailsView extends HookConsumerWidget {
  const SimilaritiesDetailsView({
    super.key,
    required this.item,
  });
  final ImageSimilarity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncImageMeta1 = ref.watch(imageMetadataProvider(item.image1Path));
    final asyncImageMeta2 = ref.watch(imageMetadataProvider(item.image2Path));

    // final controller = useExpansionTileController();
    final expanded = useState<bool>(false);

    final textStyle = context.textTheme.labelSmall;

    return ExpansionTile(
      // controller: controller,
      trailing: Icon(
        expanded.value
            ? FluentIcons.chevron_circle_down_20_regular
            : FluentIcons.chevron_circle_up_20_regular,
        size: 20,
        color: context.colorScheme.outline,
      ),
      onExpansionChanged: (value) {
        expanded.value = value;
      },
      shape: Border.symmetric(
        horizontal: BorderSide(
          color: context.colorScheme.outline.withOpacity(.7),
          width: .8,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          asyncImageMeta1.when(
            data: (data) {
              return CollapsedMetaTitle(
                expanded: expanded,
                imagePath: item.image1Path,
                data: data,
              );
            },
            error: (error, stackTrace) {
              return Text(
                path.basename(item.image1Path),
                style: textStyle,
              );
            },
            loading: () {
              return Text(
                path.basename(item.image1Path),
                style: textStyle,
              );
            },
          ),
          VerticalDivider(
            color: context.colorScheme.outline,
          ),
          asyncImageMeta2.when(
            data: (data) {
              return CollapsedMetaTitle(
                expanded: expanded,
                imagePath: item.image2Path,
                data: data,
              );
            },
            error: (error, stackTrace) {
              return Text.rich(
                TextSpan(
                  children: [
                    if (error is PathNotFoundException) ...[
                      const TextSpan(text: "File not found"),
                      const TextSpan(text: "\n"),
                    ],
                    TextSpan(
                      text: path.basename(item.image2Path),
                    ),
                  ],
                ),
                style: textStyle,
              );
            },
            loading: () {
              return Text(
                path.basename(item.image2Path),
                style: textStyle,
              );
            },
          ),
        ],
      ),
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: AsyncMetadataView(
                imagePath: item.image1Path,
              ),
            ),
            Expanded(
              child: AsyncMetadataView(
                imagePath: item.image2Path,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CollapsedMetaTitle extends StatelessWidget {
  const CollapsedMetaTitle({
    super.key,
    required this.expanded,
    required this.imagePath,
    required this.data,
  });

  final ValueNotifier<bool> expanded;
  final String imagePath;
  final ImageMetadata data;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelSmall;
    return Text.rich(
      TextSpan(
        style: textStyle?.copyWith(
          color: textStyle.color?.withOpacity(.8),
        ),
        children: [
          if (expanded.value)
            TextSpan(
              text: path.basename(imagePath),
            )
          else ...[
            TextSpan(
              children: [
                TextSpan(text: data.width.toString()),
                const TextSpan(text: " x "),
                TextSpan(text: data.height.toString()),
              ],
            ),
            TextSpan(text: "\t" * 5),
            TextSpan(
              children: [
                TextSpan(
                  text: formatFileSize(
                    data.fileSize.toString(),
                  ),
                ),
              ],
            ),
            TextSpan(text: "\t" * 5),
            TextSpan(
              children: [
                TextSpan(text: data.bitDepth.toString()),
                const TextSpan(text: " bit"),
              ],
            ),
            if (!expanded.value) ...[
              const TextSpan(text: "\n"),
              TextSpan(
                text: path.basename(imagePath),
              ),
            ]
          ]
        ],
      ),
    );
  }
}

class AsyncMetadataView extends HookConsumerWidget {
  const AsyncMetadataView({
    super.key,
    required this.imagePath,
  });
  final String imagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncImageMeta = ref.watch(imageMetadataProvider(imagePath));
    return asyncImageMeta.when(
      data: (data) {
        return Column(
          children: [
            SimilarityDetailsTile(
              title: "Dimensions",
              details: [
                data.width.toString(),
                " x ",
                data.height.toString(),
              ],
            ),
            SimilarityDetailsTile(
              title: "Bit Depth",
              details: [data.bitDepth.toString(), " bit"],
            ),
            SimilarityDetailsTile(
              title: "Size",
              details: [
                formatFileSize(
                  data.fileSize.toString(),
                ),
              ],
            ),
            SimilarityDetailsTile(
              title: "File Path",
              details: [data.path],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        if (error is PathNotFoundException) {
            return const Center(
              child: Column(
                children: [
                  Icon(
                    FluentIcons.image_off_24_filled,
                    size: 24 * 3,
                  ),
                  Text("File Missing")
                ],
              ),
            );
          }
        return AsyncErrorView(
          error: error,
          stackTrace: stackTrace,
        );
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}

class SimilarityDetailsTile extends HookConsumerWidget {
  const SimilarityDetailsTile({
    super.key,
    required this.title,
    required this.details,
  });
  final String title;
  final List<String> details;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelSmall;
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: textStyle?.copyWith(
          color: textStyle.color?.withOpacity(.5),
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: details.map((detail) {
            return TextSpan(text: detail);
          }).toList(),
        ),
        style: textStyle,
      ),
    );
  }
}
