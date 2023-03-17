
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photographic_viewer/thumbnails.dart';
import 'package:photographic_viewer/util/controller.dart';

const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

class ViewerKeyEvent {
  ViewerKeyEvent({required this.controller, required this.thumbnails});

  final Controller controller;
  final ThumbnailsState? thumbnails;

  KeyEventResult getListener(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(thumbnails != null) {
        if (prevKeys.contains(event.logicalKey)) {
          thumbnails!.prev();
          return KeyEventResult.handled;
        }
        if (nextKeys.contains(event.logicalKey)) {
          thumbnails!.next();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.home) {
          thumbnails!.start();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.end) {
          thumbnails!.end();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          thumbnails!.nextPage();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          thumbnails!.prevPage();
          return KeyEventResult.handled;
        }
      }
      if(event.logicalKey == LogicalKeyboardKey.keyO) {
        controller.runPickFile();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.keyR && controller.isOpenImage()) {
        controller.reload();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.keyS && controller.shareable()) {
        controller.runShare();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.keyC && controller.isOpenImage()) {
        controller.copyDesktop();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.delete && controller.isOpenImage()) {
        controller.deleteFile();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }
}
