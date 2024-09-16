import 'package:flutter/material.dart';
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
        Flexible(
          child: Container(
            color: context.colorScheme.surfaceContainer,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 0.4,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Shimmered(
                    width: 50,
                    height: 50,
                    color: color,
                  ),
                  title: Shimmered(
                    width: 100,
                    height: 14,
                    borderRadius: 500.0,
                    color: color,
                  ),
                  trailing: Shimmered(
                    width: 14,
                    height: 14,
                    borderRadius: 500.0,
                    color: color,
                  ),
                );
              },
            ),
          ),
        ),
        const VerticalDivider(
          width: 2.0,
        ),
        Flexible(
          flex: 3,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              children: [
                Flexible(
                  flex: 7,
                  child: Column(
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Shimmered(
                              margin: const EdgeInsets.all(8.0),
                              color: color,
                              width: 24,
                              height: 24,
                            ),
                            const Spacer(),
                            Shimmered(
                              margin: const EdgeInsets.all(8.0),
                              color: color,
                              width: 24,
                              height: 24,
                            ),
                            Shimmered(
                              margin: const EdgeInsets.all(8.0),
                              color: color,
                              width: 24,
                              height: 24,
                            ),
                            const Spacer(),
                            Shimmered(
                              margin: const EdgeInsets.all(8.0),
                              color: color,
                              width: 24,
                              height: 24,
                            ),
                          ],
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
                        flex: 4,
                        child: Container(
                          color: context.colorScheme.surfaceContainer,
                          child: Row(
                            children: [
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  itemCount: 2,
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
                                  itemCount: 2,
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
                const VerticalDivider(
                  width: 2.0,
                ),
                Flexible(
                  child: Center(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      shrinkWrap: true,
                      itemCount: 5,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return AspectRatio(
                          aspectRatio: 1,
                          child: Shimmered(
                            borderRadius: 5.0,
                            color: context.colorScheme.surfaceContainerHigh,
                          ),
                        );
                      },
                    ),
                  ),
                )
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
