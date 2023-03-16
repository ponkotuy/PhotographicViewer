import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photographic_viewer/my_app_bar.dart';
import 'package:photographic_viewer/util/viewer_key_event.dart';
import '../thumbnails.dart';
import 'package:collection/collection.dart';

import 'image.dart';
import 'util/image_file.dart';

void main(List<String> arguments) {
  final String? firstArg = arguments.firstOrNull;
  final initFile = firstArg == null ? null : File(firstArg);
  runApp(MyApp(initFile: initFile,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.initFile}) : super(key: key);

  final File? initFile;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photographic Viewer',
      theme: ThemeData.dark(),
      home: Main(initFile: initFile),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key, this.initFile}) : super(key: key);

  final File? initFile;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  File? dir;
  ImageFile? file;
  final GlobalKey<ThumbnailsState> _thumbnailKey = GlobalKey();

  void _pickFile(File file) async {
    setState(() {
      dir = file;
    });
    _thumbnailKey.currentState?.pickFile(file);
  }

  void _reload() {
    if(dir != null) _pickFile(dir!);
  }

  void changeFile(ImageFile image) {
    setState(() {
      file = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.initFile != null) _pickFile(widget.initFile!);
    final thumbnails = Thumbnails(changeFile: changeFile, dir: dir, key: _thumbnailKey);
    final keyEvent = _thumbnailKey.currentState == null ? null :
      ViewerKeyEvent(
        thumbnails: _thumbnailKey.currentState!,
        target: file?.file,
        reload: _reload
      );
    return Focus(
      autofocus: true,
      onKeyEvent: keyEvent?.getListener,
      child: Scaffold(
        appBar: MyAppBar(pickFile: _pickFile, target: file?.file, reload: _reload),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              file != null ? Expanded(child: ImageWidget(file: file)) : noneText(context),
              thumbnails,
            ]
          )
        )
      )
    );
  }

  Widget noneText(BuildContext context) {
    return Text("None", style: Theme.of(context).textTheme.headlineMedium);
  }
}
