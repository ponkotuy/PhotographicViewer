import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int _selectedIdx = 0;

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

  Widget thumbElem(int idx, bool selected) {
    Image image = Image.file(_thumbnails.elementAt(idx), width: 200.0,);
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
      onTap: () => setState(() { _currentIdx = idx; }),
      child: image,
    );
  }

  Widget thumbnails() {
    final start = max(0, _currentIdx - 2);
    final end = min(start + 5, _thumbnails.length);
    return SizedBox(
      width: 240.0,
      child: ListView(
        children: [for(var i=start; i<end; i+=1) i].map((i) => thumbElem(i, (i - start) == _selectedIdx)).toList(),
      ),
    );
  }

  static const prevKeys = [LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.arrowLeft];
  static const nextKeys = [LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.arrowUp];

  KeyEventResult shortcutKey(FocusNode node, KeyEvent event) {
    if(event is KeyDownEvent) {
      if(prevKeys.contains(event.logicalKey)) {
        setState(() {
          _currentIdx = max(0, _currentIdx - 1);
          _selectedIdx = min(_currentIdx, 2);
        });
        return KeyEventResult.handled;
      }
      if(nextKeys.contains(event.logicalKey)) {
        setState(() {
          _currentIdx = min(_currentIdx + 1, _thumbnails.length);
          _selectedIdx = min(_currentIdx, 2);
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    _selectedIdx = min(_currentIdx, 2);
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
              thumbnails(),
            ],
          ),
        ),
      ),
    );
  }
}
