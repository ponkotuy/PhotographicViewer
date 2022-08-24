
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_native_drag_n_drop/flutter_native_drag_n_drop.dart';

import 'image.dart';

class DraggableImageWidget extends StatelessWidget {
  const DraggableImageWidget({Key? key, required this.file}) : super(key: key);

  final File? file;

  @override
  Widget build(BuildContext context) {
    if(file == null) {
      return Text('None', style: Theme.of(context).textTheme.headline4,);
    }

    final fileName = basename(file!.path);
    final fileSize = file!.lengthSync();
    return Expanded(
      child: NativeDraggable(
        fileItems: [NativeDragFileItem(fileName: fileName, fileSize: fileSize)],
        fileStreamCallback: passFileContent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(file: file),
          ],
        ),
      )
    );
  }

  Stream<Uint8List> passFileContent(
    NativeDragItem<Object> item,
    String fileName,
    String url,
    ProgressController progressController) async* {
      final fileStream = file!.openRead();
      await for (final chunk in fileStream) {
        yield Uint8List.fromList(chunk);
      }
  }
}

