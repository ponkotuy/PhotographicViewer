import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photographic_viewer/image.dart';
import 'package:photographic_viewer/my_app_bar.dart';
import 'package:photographic_viewer/thumbnails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photographic Viewer',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<File> _thumbnails = [];
  int _currentIdx = -1;

  static const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
  static const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

  void _pickFile(File file) {
    setState(() {
      _thumbnails = file.parent.listSync().whereType<File>().toList();
      _currentIdx = _thumbnails.map((e) => e.path).toList().indexOf(file.path);
    });
  }

  KeyEventResult shortcutKey(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(prevKeys.contains(event.logicalKey)) {
        setState(() { _currentIdx = max(0, _currentIdx - 1); });
        return KeyEventResult.handled;
      }
      if(nextKeys.contains(event.logicalKey)) {
        setState(() { _currentIdx = min(_currentIdx + 1, _thumbnails.length); });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(pickFile: _pickFile,),
      body: Focus(
        autofocus: true,
        onKeyEvent: shortcutKey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageWidget(file: _currentIdx < 0 ? null : _thumbnails[_currentIdx]),
              Thumbnails(
                thumbnails: _thumbnails,
                onTap: (idx) => setState(() { _currentIdx = idx; }),
                index: _currentIdx
              ),
            ],
          ),
        ),
      ),
    );
  }
}
