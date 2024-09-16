
import 'package:flutter/material.dart';
import 'package:looks_like_it/models/similar_image.dart';
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

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: ListView(
        children: [
          // ImageInfoTile(
          //   label: "Id",
          //   info: Text(image.id.toString()),
          // ),
          ImageInfoTile(
            label: "Size Info",
            info: DimensionsView(
              image: image,
            ),
          ),
          const Divider(
            height: 2,
          ),
          ImageInfoTile(
            label: "File Path",
            info: Text(imagePath),
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
    required this.image,
  });

  final SimilarImage? image;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            children: [
              TextSpan(
                text: image?.width.toString(),
              ),
              TextSpan(
                text: " x ",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              TextSpan(
                text: image?.height.toString(),
              ),
              const TextSpan(text: "\t\t")
            ],
          ),
          TextSpan(
            children: [
              TextSpan(
                text: formatFileSize(image?.size),
              )
            ],
          ),
        ],
      ),
    );
  }
}
