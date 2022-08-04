
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class Thumbnails extends StatelessWidget {
  const Thumbnails({Key? key, required this.thumbnails, required this.onTap, required this.index}) : super(key: key);
  final List<File> thumbnails;
  final void Function(int) onTap;
  final int index;

  int selectedIdx() {
    return min(index , 2);
  }

  @override
  Widget build(BuildContext context) {
    final start = max(0, index - 2);
    final end = min(start + 5, thumbnails.length);
    return SizedBox(
      width: 240.0,
      child: ListView(
        children: [for(var i=start; i<end; i+=1) i].map((i) =>
            ThumbnailElement(
              file: thumbnails[i],
              selected: (i - start) == selectedIdx(),
              onTap: () => onTap(i),
            )
        ).toList(),
      ),
    );
  }
}

class ThumbnailElement extends StatelessWidget {
  const ThumbnailElement({Key? key, required this.file, required this.selected, required this.onTap}) : super(key: key);
  final File file;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Image image = Image.file(file, width: 200.0, cacheWidth: 200,);
    if(selected) {
      return Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).selectedRowColor, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: image,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: image,
    );
  }
}
