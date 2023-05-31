
import 'package:flutter/material.dart';
import 'package:photographic_viewer/util/controller.dart';

import 'icon_text_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.controller}) : super(key: key);

  final Controller controller;

  Color primary(BuildContext context) {
    return Theme.of(context).colorScheme.inversePrimary;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconTextButton(
          onPressed: controller.runPickFile,
          icon: const Icon(Icons.file_open),
          text: const Text('Open'),
          shortcutKey: 'o',
          color: primary(context),
        ),
        IconTextButton(
          onPressed: controller.isOpenImage() ? controller.runReload : null,
          icon: const Icon(Icons.refresh),
          text: const Text('Reload dir'),
          shortcutKey: 'r',
          color: primary(context)
        ),
        IconTextButton(
          onPressed: controller.shareable() ? controller.runShare : null,
          icon: const Icon(Icons.share),
          text: const Text('Share'),
          shortcutKey: 's',
          color: primary(context),
        ),
        IconTextButton(
          onPressed: controller.isOpenImage() ? controller.copyDesktop : null,
          icon: const Icon(Icons.content_copy),
          text: const Text('Copy desktop'),
          shortcutKey: 'c',
          color: primary(context),
        ),
        IconTextButton(
          onPressed: controller.isOpenImage() ? controller.deleteFile : null,
          icon: const Icon(Icons.delete),
          text: const Text('Delete'),
          shortcutKey: 'del/BS',
          color: primary(context),
        ),
      ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
