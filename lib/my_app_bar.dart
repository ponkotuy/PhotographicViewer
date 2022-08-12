
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart';

const imageExtensions = ["bmp", "gif", "jpg", "jpeg", "jpg", "png", "BMP", "GIF", "JPG", "JPEG", "JPG", "PNG"];

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.pickFile, this.target, required this.reload}) : super(key: key);

  final void Function(File) pickFile;
  final File? target;
  final void Function() reload;

  void runPickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowedExtensions: imageExtensions);
    if (result != null) {
      String? path = result.files.single.path;
      if(path != null) {
        pickFile(File(path));
      }
    }
  }

  void runShare() async {
    await Share.shareFiles([target!.path]);
  }

  void copyDesktop() {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if(home != null) target!.copySync(join(home, 'Desktop', basename(target!.path)));
  }

  void deleteFile() {
    target!.delete();
    reload();
  }

  bool shareable() {
    return target != null && Platform.isMacOS;
  }

  bool isOpenImage() {
    return target != null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconTextButton(
          onPressed: runPickFile,
          icon: const Icon(IconData(0xf04ff, fontFamily: 'MaterialIcons')),
          text: const Text('Open'),
        ),
        IconTextButton(
          onPressed: shareable() ? runShare : null,
          icon: const Icon(IconData(0xe593, fontFamily: "MaterialIcons")),
          text: const Text('Share'),
        ),
        IconTextButton(
          onPressed: isOpenImage() ? copyDesktop : null,
          icon: const Icon(IconData(0xe190, fontFamily: 'MaterialIcons')),
          text: const Text('Copy desktop'),
        ),
        IconTextButton(
          onPressed: isOpenImage() ? deleteFile : null,
          icon: const Icon(IconData(0xe1b9, fontFamily: 'MaterialIcons')),
          text: const Text('Delete')
        ),
      ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class IconTextButton extends StatelessWidget {
  const IconTextButton({Key? key, required this.onPressed, required this.icon, required this.text}) : super(key: key);

  final VoidCallback? onPressed;
  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Flexible(child: text),
        ],
      )
    );
  }
}
