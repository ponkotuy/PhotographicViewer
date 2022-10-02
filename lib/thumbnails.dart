
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photographic_viewer/draggable.dart';

class Thumbnails extends StatelessWidget {
  Thumbnails({Key? key, required this.thumbnails, required this.onTap, required this.index}) : super(key: key);

  final List<File> thumbnails;
  final void Function(int) onTap;
  final int index;
  final GlobalKey selectedKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  void scrollSelected(int index) {
    final height = min(max(0, index - 1) * 162.5, scrollController.position.maxScrollExtent);
    scrollController.jumpTo(height);
  }

  @override
  Widget build(BuildContext context) {
    if(thumbnails.isEmpty) return Container();
    final widget = SizedBox(
      width: 260.0,
      child: ListView.builder(
        controller: scrollController,
        itemCount: thumbnails.length,
        itemBuilder: (context, i) {
          return ThumbnailElement(
            key: i == index ? selectedKey : null,
            file: thumbnails[i],
            selected: i == index,
            onTap: () => onTap(i),
          );
        },
      )
    );
    return widget;
  }
}

class ThumbnailElement extends StatelessWidget {
  const ThumbnailElement({Key? key, required this.file, required this.selected, required this.onTap}) : super(key: key);
  final File file;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Image image = Image.file(file, width: 240.0, height: 160.0, cacheWidth: 240, fit: BoxFit.contain,);
    if(selected) {
      return DraggableWidget(file: file, child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).selectedRowColor, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: image,
      ));
    }
    return DraggableWidget(file: file, child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: image
      )
    ));
  }
}
