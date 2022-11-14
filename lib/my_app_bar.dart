
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

  void runReload() async {
    reload();
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

  Color primary(BuildContext context) {
    return Theme.of(context).colorScheme.inversePrimary;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconTextButton(
          onPressed: runPickFile,
          icon: const Icon(Icons.file_open),
          text: const Text('Open'),
          color: primary(context),
        ),
        IconTextButton(
          onPressed: isOpenImage() ? runReload : null,
          icon: const Icon(Icons.refresh),
          text: const Text('Reload dir'),
          color: primary(context)
        ),
        IconTextButton(
          onPressed: shareable() ? runShare : null,
          icon: const Icon(Icons.share),
          text: const Text('Share'),
          color: primary(context),
        ),
        IconTextButton(
          onPressed: isOpenImage() ? copyDesktop : null,
          icon: const Icon(Icons.content_copy),
          text: const Text('Copy desktop'),
          color: primary(context),
        ),
        IconTextButton(
          onPressed: isOpenImage() ? deleteFile : null,
          icon: const Icon(Icons.delete),
          text: const Text('Delete'),
          color: primary(context),
        ),
      ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class IconTextButton extends StatelessWidget {
  const IconTextButton({Key? key, required this.onPressed, required this.icon, required this.text, required this.color}) : super(key: key);

  final VoidCallback? onPressed;
  final Icon icon;
  final Text text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: color),
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
