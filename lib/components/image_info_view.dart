import 'package:flutter/material.dart';
import 'package:looks_like_it/models/similar_image/similar_image.dart';
import 'package:looks_like_it/utils/functions.dart';

class ImageInfoView extends StatelessWidget {
  const ImageInfoView({
    super.key,
    required this.image,
  });

  final SimilarImage image;

  @override
  Widget build(BuildContext context) {
    final imagePath = image.imagePath;
    final imageSize = image.imageInfo?.size;

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListView(
        children: [
          ImageInfoTile(
            label: "Dimensions",
            info: DimensionsView(
              dimensions: image.imageInfo?.dimensions,
            ),
          ),
          ImageInfoTile(
            label :"Size",
            info: Text(formatFileSize(imageSize)),
          ),
          ImageInfoTile(
            label:"Path",
            info: Text(imagePath ?? ""),
          ),
        ],
      ),
    );
  }
}

class ImageInfoTile extends StatelessWidget {
  const ImageInfoTile({
    super.key,
    required this.label,
    required this.info,
  });

  final String label;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      subtitle: info,
    );
  }
}

class DimensionsView extends StatelessWidget {
  const DimensionsView({
    super.key,
    required this.dimensions,
  });

  final ({int height, int width})? dimensions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                children: [
                  TextSpan(
                    text: "Width: ",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  TextSpan(
                    text: dimensions?.width.toString(),
                  )
                ],
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                children: [
                  TextSpan(
                    text: "Height: ",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  TextSpan(
                    text: dimensions?.height.toString(),
                  )
                ],
              ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
