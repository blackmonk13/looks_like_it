import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _UndoHistoryControllerHook extends Hook<UndoHistoryController> {
  const _UndoHistoryControllerHook([List<Object?>? keys]) : super(keys: keys);

  @override
  _UndoHistoryControllerHookState createState() => _UndoHistoryControllerHookState();
}

class _UndoHistoryControllerHookState
    extends HookState<UndoHistoryController, _UndoHistoryControllerHook> {
  late final controller = UndoHistoryController();

  @override
  UndoHistoryController build(BuildContext context) => controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  String get debugLabel => 'useUndoHistoryController';
}

UndoHistoryController useUndoHistoryController() => use(const _UndoHistoryControllerHook());
