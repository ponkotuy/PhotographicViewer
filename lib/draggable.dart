
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_native_drag_n_drop/flutter_native_drag_n_drop.dart';

class DraggableWidget extends StatelessWidget {
  const DraggableWidget({Key? key, required this.file, required this.child}) : super(key: key);

  final File file;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fileName = basename(file.path);
    final fileSize = file.lengthSync();
    return NativeDraggable(
      fileItems: [NativeDragFileItem(fileName: fileName, fileSize: fileSize)],
      fileStreamCallback: passFileContent,
      child: child
    );
  }

  Stream<Uint8List> passFileContent(
    NativeDragItem<Object> item,
    String fileName,
    String url,
    ProgressController progress
  ) async* {
    print(fileName);
    final fileStream = file.openRead();
    final output = File(fileName);
    await for (final chunk in fileStream) {
      output.writeAsBytes(chunk);
      progress.updateProgress(chunk.length);
      yield Uint8List.fromList(chunk);
    }
  }
}
