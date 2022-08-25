import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photographic_viewer/draggable_image.dart';
import 'package:photographic_viewer/exif_parser.dart';
import 'package:photographic_viewer/my_app_bar.dart';
import 'package:photographic_viewer/thumbnails.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
  List<File> _thumbnails = [];
  int _currentIdx = -1;
  Thumbnails? _thumbWidget;

  static const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
  static const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

  void _pickFile(File file) async {
    final thumbnails = file.parent.listSync()
        .whereType<File>()
        .where((e) => extension(e.path).isNotEmpty && imageExtensions.contains(extension(e.path).substring(1)))
        .toList();
    final exifs = { for (var e in thumbnails) e.path : (await ExifParser.parseCreateDate(e)) };
    thumbnails.sort((a, b) => (exifs[a.path] ?? "a").compareTo(exifs[b.path] ?? "a"));
    setState(() {
      _thumbnails = thumbnails;
      _currentIdx = thumbnails.map((e) => e.path).toList().indexOf(file.path);
    });
  }

  void _reload() {
    setState(() {
      _thumbnails.removeWhere((f) => !f.existsSync());
    });
  }

  void changeImage(int index) {
    if(index == _currentIdx) return;
    setState(() {
      _currentIdx = index;
    });
    _thumbWidget?.scrollSelected(index);
  }

  KeyEventResult shortcutKey(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(prevKeys.contains(event.logicalKey)) {
        changeImage(max(0, _currentIdx - 1));
        return KeyEventResult.handled;
      }
      if(nextKeys.contains(event.logicalKey)) {
        changeImage(min(_currentIdx + 1, _thumbnails.length - 1));
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.initFile != null && _currentIdx == -1) _pickFile(widget.initFile!);
    final file = _currentIdx < 0 ? null : _thumbnails[_currentIdx];
    _thumbWidget = Thumbnails(
      thumbnails: _thumbnails,
      onTap: changeImage,
      index: _currentIdx,
    );
    return Focus(
      autofocus: true,
      onKeyEvent: shortcutKey,
      child: Scaffold(
        appBar: MyAppBar(pickFile: _pickFile, target: file, reload: _reload),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DraggableImageWidget(file: file),
              _thumbWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
