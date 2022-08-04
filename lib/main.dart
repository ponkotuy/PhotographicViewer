import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: const MyHomePage(title: 'Photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _thumbnails = [];
  int _currentIdx = 0;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        String? path = result.files.single.path;
        if(path != null) {
          _thumbnails = File(path).parent.listSync().whereType<File>().toList();
          _currentIdx = _thumbnails.map((e) => e.path).toList().indexOf(path);
        }
      }
    });
  }

  Widget image() {
    if(_thumbnails.isEmpty) {
      return Text(
        'None', style: Theme.of(context).textTheme.headline4,
      );
    }
    final file = _thumbnails.elementAt(_currentIdx);
    return Expanded(
        child: Image(
          image: FileImage(file),
        )
    );
  }

  static const prevKeys = [LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowLeft];
  static const nextKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowRight];

  KeyEventResult shortcutKey(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(prevKeys.contains(event.logicalKey)) {
        setState(() {
          _currentIdx = max(0, _currentIdx - 1);
        });
        return KeyEventResult.handled;
      }
      if(nextKeys.contains(event.logicalKey)) {
        setState(() {
          _currentIdx = min(_currentIdx + 1, _thumbnails.length);
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(IconData(0xf04ff, fontFamily: 'MaterialIcons')),
              title: const Text('Open file'),
              onTap: _pickFile,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: shortcutKey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image(),
              Thumbnails(
                thumbnails: _thumbnails,
                onTap: (idx) => _currentIdx = idx,
                index: _currentIdx
              ),
            ],
          ),
        ),
      ),
    );
  }
}
