
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

const imageExtensions = ["bmp", "gif", "jpg", "jpeg", "jpg", "png", "BMP", "GIF", "JPG", "JPEG", "JPG", "PNG"];

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.pickFile}) : super(key: key);

  final void Function(File) pickFile;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: imageExtensions);
    if (result != null) {
      String? path = result.files.single.path;
      if(path != null) {
        pickFile(File(path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(onPressed: _pickFile, icon: const Icon(IconData(0xf04ff, fontFamily: 'MaterialIcons'))),
      ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
