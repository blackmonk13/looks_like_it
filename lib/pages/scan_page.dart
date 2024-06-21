import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:looks_like_it/providers/common.dart';

import 'package:looks_like_it/components/similarities_view.dart';
import 'package:looks_like_it/utils/extensions.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSimilarities = ref.watch(similaritiesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surfaceContainer,
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0,),
        ),
      ),
      body: asyncSimilarities.when(
        data: (data) {
          // return const ScanLoader();
          if (data == null) {
            return Center(
              child: Text(
                "No similarities found",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
          return SimilaritiesView(
            data: data,
          );
        },
        error: (error, stackTrace) {
          return Text(
            error.toString(),
          );
        },
        loading: () {
          return const ScanLoader();
        },
      ),
    );
  }
}

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
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: color,
                    ),
                  ),
                  title: Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500.0),
                      color: color,
                    ),
                  ),
                  trailing: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(500.0),
                      color: color,
                    ),
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
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            const VerticalDivider(
                              width: 2.0,
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 24.0,
                        width: 100.0,
                        height: MediaQuery.of(context).size.height * .9,
                        child: Center(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shrinkWrap: true,
                            itemCount: 3,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox.square(
                                dimension: 95.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: color,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2.0,
                ),
                Flexible(
                  child: Container(
                    color: context.colorScheme.surfaceContainer,
                    child: Row(
                      children: [
                        Flexible(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            itemCount: 3,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Container(
                                  width: 30,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500.0),
                                    color: color,
                                  ),
                                ),
                                subtitle: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500.0),
                                    color: color,
                                  ),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            itemCount: 3,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Container(
                                  width: 30,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500.0),
                                    color: color,
                                  ),
                                ),
                                subtitle: Container(
                                  width: 60,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(500.0),
                                    color: color,
                                  ),
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
        ),
      ],
    );
  }
}
