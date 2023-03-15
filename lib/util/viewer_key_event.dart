

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photographic_viewer/thumbnails.dart';

const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

class ViewerKeyEvent {
  ViewerKeyEvent(this.thumbnails);

  final ThumbnailsState thumbnails;

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
    }
    return KeyEventResult.ignored;
  }
}
