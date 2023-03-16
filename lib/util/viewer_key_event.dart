

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photographic_viewer/thumbnails.dart';

const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

class ViewerKeyEvent {
  ViewerKeyEvent({required this.thumbnails, this.target, required this.reload});

  final ThumbnailsState thumbnails;
  final File? target;
  final void Function() reload;

  KeyEventResult getListener(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(prevKeys.contains(event.logicalKey)) {
        thumbnails.prev();
        return KeyEventResult.handled;
      }
      if(nextKeys.contains(event.logicalKey)) {
        thumbnails.next();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.home) {
        thumbnails.start();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.end) {
        thumbnails.end();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.pageDown) {
        thumbnails.nextPage();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.pageUp) {
        thumbnails.prevPage();
        return KeyEventResult.handled;
      }
      if(event.logicalKey == LogicalKeyboardKey.delete) {
        target!.delete();
        reload();
      }
    }
    return KeyEventResult.ignored;
  }
}
