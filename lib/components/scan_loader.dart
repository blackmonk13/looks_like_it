import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:looks_like_it/components/similarity_list_tile.dart';
import 'package:looks_like_it/utils/extensions.dart';
import 'package:shimmer/shimmer.dart';

class ScanLoader extends StatelessWidget {
  const ScanLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = colorScheme.surfaceContainerHigh;
    return Row(
      children: [
        ...context.layout.value<List<Widget>>(
          xs: [const SizedBox.shrink()],
          sm: context.layout.width < 800
              ? [const SizedBox.shrink()]
              : [
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: 10,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: .5,
                          color: context.colorScheme.outline.withOpacity(.5),
                          indent: 60,
                          endIndent: 60,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return const SimilarityListTileLoading();
                      },
                    ),
                  ),
                  VerticalDivider(
                    thickness: .5,
                    color: context.colorScheme.outline.withOpacity(.5),
                    width: 0.5,
                  ),
                ],
        ),
        Flexible(
          flex: context.layout.value(
            xs: 4,
            sm: context.layout.width < 900 ? 5 : 3,
          ),
          child: Container(
            color: context.colorScheme.surface,
            child: Row(
              children: [
                Flexible(
                  flex: 7,
                  child: Column(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              const Spacer(),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                              const Spacer(),
                              Shimmered(
                                margin: const EdgeInsets.all(8.0),
                                color: color,
                                width: 20,
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 2.0,
                      ),
                      Flexible(
                        flex: 9,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Shimmered(
                                      margin: const EdgeInsets.all(16.0),
                                      color: colorScheme.surfaceContainerHigh,
                                      borderRadius: 5.0,
                                    ),
                                  ),
                                  const VerticalDivider(
                                    width: 2.0,
                                  ),
                                  Flexible(
                                    child: Shimmered(
                                      margin: const EdgeInsets.all(16.0),
                                      color: colorScheme.surfaceContainerHigh,
                                      borderRadius: 5.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: context.colorScheme.surface,
                          child: Row(
                            children: [
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  itemCount: 1,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      dense: true,
                                      title: Row(
                                        children: [
                                          Shimmered(
                                            width: 50,
                                            height: 10,
                                            borderRadius: 500.0,
                                            color: color,
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Shimmered(
                                            width: 200,
                                            height: 14,
                                            borderRadius: 500.0,
                                            color: color,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const VerticalDivider(
                                width: 2.0,
                              ),
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  itemCount: 1,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      dense: true,
                                      title: Row(
                                        children: [
                                          Shimmered(
                                            width: 50,
                                            height: 10,
                                            borderRadius: 500.0,
                                            color: color,
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Shimmered(
                                            width: 200,
                                            height: 14,
                                            borderRadius: 500.0,
                                            color: color,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Shimmered extends StatelessWidget {
  const Shimmered({
    super.key,
    required this.color,
    this.borderRadius = 5.0,
    this.width,
    this.height,
    this.margin,
  });

  final double? width;
  final double? height;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surfaceContainerHigh,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
      ),
    );
  }
}
