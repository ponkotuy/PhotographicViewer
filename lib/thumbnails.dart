
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photographic_viewer/thumbnail_element.dart';
import 'package:photographic_viewer/util/constant.dart';

import 'exif_parser.dart';
import 'util/image_file.dart';

class Thumbnails extends StatefulWidget {
  Thumbnails({required this.changeFile, this.dir, Key? key}) : super(key: key);

  final File? dir;
  final void Function(ImageFile) changeFile;
  final GlobalKey selectedKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  
  void scrollSelected(int index) {
    final height = min(max(0, index - 1) * 162.5, scrollController.position.maxScrollExtent);
    scrollController.jumpTo(height);
  }

  @override
  State<StatefulWidget> createState() => ThumbnailsState();
}

class ThumbnailsState extends State<Thumbnails> {
  List<ImageFile> images = [];
  int currentIdx = -1;
  final containerKey = GlobalKey();

  void change(int index) {
    if(index == currentIdx) return;
    setState(() {
      currentIdx = index;
    });
    widget.scrollSelected(index);
    widget.changeFile(images[currentIdx]);
  }

  void next() { change(min(currentIdx + 1, images.length - 1)); }
  void prev() { change(max(0, currentIdx - 1)); }

  void start() { change(0); }
  void end() { change(images.length - 1); }

  int pageSize() { return ((containerKey.currentContext?.size?.height ?? 480) / 170).round(); }
  void nextPage() { change(min(currentIdx + pageSize(), images.length - 1)); }
  void prevPage() { change(max(0, currentIdx - pageSize())); }

  void pickFile(File dir) async {
    final files = dir.parent.listSync()
        .whereType<File>()
        .where((e) => extension(e.path).isNotEmpty && imageExtensions.contains(extension(e.path).substring(1)))
        .toList();
    final xs = [for (final f in files) ImageFile(f, (await ExifParser.parse(f)))];
    xs.sort();
    setState(() {
      images = xs;
      currentIdx = xs.map((e) => e.file.path).toList().indexOf(dir.path);
    });
    widget.changeFile(images[currentIdx]);
  }

  ImageFile? getImage() {
    return currentIdx == -1 ? null : images[currentIdx];
  }

  @override
  Widget build(BuildContext context) {
    if(currentIdx == -1 && widget.dir != null) pickFile(widget.dir!);
    if(images.isEmpty) return Container();
    final result = SizedBox(
      width: 260.0,
      key: containerKey,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: images.length,
        itemBuilder: (context, i) {
          return ThumbnailElement(
            key: i == currentIdx ? widget.selectedKey : null,
            imageFile: images[i],
            selected: i == currentIdx,
            onTap: () => change(i)
          );
        },
      )
    );
    return result;
  }
}
