import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/imagehash/image_hashing.dart';
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
    // final controller = useExpansionTileController();
    final expanded = useState<bool>(false);

    final image1 = item.image1.value;
    final image2 = item.image2.value;

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
          Expanded(
            child: CollapsedMetaTitle(
              expanded: expanded,
              data: image1,
            ),
          ),
          VerticalDivider(
            color: context.colorScheme.outline,
          ),
          Expanded(
            child: CollapsedMetaTitle(
              expanded: expanded,
              data: image2,
            ),
          ),
        ],
      ),
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: AsyncMetadataView(
                image: image1,
              ),
            ),
            Expanded(
              child: AsyncMetadataView(
                image: image2,
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
    required this.data,
  });

  final ValueNotifier<bool> expanded;
  final ImageEntry? data;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelSmall;

    if (data == null) {
      return Text.rich(
        const TextSpan(
          children: [
            TextSpan(text: "File not found"),
            TextSpan(text: "\n"),
          ],
        ),
        style: textStyle,
        maxLines: 1,
      );
    }

    return Text.rich(
      TextSpan(
        style: textStyle?.copyWith(
          color: textStyle.color?.withOpacity(.8),
        ),
        children: [
          if (expanded.value)
            TextSpan(
              text: path.basename(data!.imagePath),
            )
          else ...[
            TextSpan(
              children: [
                TextSpan(text: data!.width.toString()),
                const TextSpan(text: " x "),
                TextSpan(text: data!.height.toString()),
              ],
            ),
            TextSpan(text: "\t" * 5),
            TextSpan(
              children: [
                TextSpan(
                  text: formatFileSize(
                    data!.fileSize.toString(),
                  ),
                ),
              ],
            ),
            TextSpan(text: "\t" * 5),
            TextSpan(
              children: [
                TextSpan(text: data!.bitDepth.toString()),
                const TextSpan(text: " bit"),
              ],
            ),
            if (!expanded.value) ...[
              const TextSpan(text: "\n"),
              TextSpan(
                text: path.basename(data!.imagePath),
              ),
            ]
          ]
        ],
      ),
      maxLines: 2,
    );
  }
}

class AsyncMetadataView extends HookConsumerWidget {
  const AsyncMetadataView({
    super.key,
    required this.image,
  });
  final ImageEntry? image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (image == null) {
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

    return Column(
      children: [
        SimilarityDetailsTile(
          title: "Dimensions",
          details: [
            image!.width.toString(),
            " x ",
            image!.height.toString(),
          ],
        ),
        SimilarityDetailsTile(
          title: "Bit Depth",
          details: [image!.bitDepth.toString(), " bit"],
        ),
        SimilarityDetailsTile(
          title: "Size",
          details: [
            formatFileSize(
              image!.fileSize.toString(),
            ),
          ],
        ),
        SimilarityDetailsTile(
          title: "File Path",
          details: [image!.imagePath],
        ),
      ],
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
