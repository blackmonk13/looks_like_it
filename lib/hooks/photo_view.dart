import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

class _PhotoViewControllerHook extends Hook<PhotoViewController> {
  const _PhotoViewControllerHook({
    this.initialPosition = Offset.zero,
    this.initialRotation = 0.0,
    this.initialScale,
    super.keys,
  });
  final Offset initialPosition;
  final double initialRotation;
  final double? initialScale;

  @override
  _PhotoViewControllerHookState createState() =>
      _PhotoViewControllerHookState();
}

class _PhotoViewControllerHookState
    extends HookState<PhotoViewController, _PhotoViewControllerHook> {
  late final controller = PhotoViewController(
    initialPosition: hook.initialPosition,
    initialRotation: hook.initialRotation,
    initialScale: hook.initialScale,
  );

  @override
  PhotoViewController build(BuildContext context) => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  String get debugLabel => 'usePhotoViewController';
}

PhotoViewController usePhotoViewController({
  Offset initialPosition = Offset.zero,
  double initialRotation = 0.0,
  double? initialScale,
  List<Object?>? keys,
}) =>
    use(_PhotoViewControllerHook(
      initialPosition: initialPosition,
      initialRotation: initialRotation,
      initialScale: initialScale,
      keys: keys,
    ));

class _PhotoViewScaleStateControllerHook
    extends Hook<PhotoViewScaleStateController> {
  const _PhotoViewScaleStateControllerHook({super.keys});

  @override
  _PhotoViewScaleStateControllerHookState createState() =>
      _PhotoViewScaleStateControllerHookState();
}

class _PhotoViewScaleStateControllerHookState extends HookState<
    PhotoViewScaleStateController, _PhotoViewScaleStateControllerHook> {
  late final controller = PhotoViewScaleStateController();

  @override
  PhotoViewScaleStateController build(BuildContext context) => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  String get debugLabel => 'usePhotoViewScaleStateController';
}

PhotoViewScaleStateController usePhotoViewScaleStateController({
  List<Object?>? keys,
}) =>
    use(_PhotoViewScaleStateControllerHook(
      keys: keys,
    ));
