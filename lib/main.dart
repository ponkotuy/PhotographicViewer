import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
  File? _file;
  List<File> _thumbnails = [];
  int _currentIdx = 0;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null) {
        String? path = result.files.single.path;
        if(path != null) {
          _file = File(path);
          _thumbnails = _file!.parent.listSync().whereType<File>().toList();
          _currentIdx = _thumbnails.indexOf(_file!);
        }
      }
    });
  }

  Widget image() {
    if(_file == null) {
      return Text(
        'None', style: Theme.of(context).textTheme.headline4,
      );
    }
    File file = _file!;
    return Expanded(
        child: Image(
          image: FileImage(file),
        )
    );
  }

  Widget thumbnails() {
    return SizedBox(
      width: 240.0,
      child: ListView(
        children: _thumbnails.map((e) =>
            Image.file(e, width: 200.0,)
        ).toList(),
      ),
    );
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image(),
            thumbnails(),
          ],
        ),
      ),
    );
  }
}
