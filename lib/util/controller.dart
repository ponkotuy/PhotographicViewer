
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

import 'constant.dart';

class Controller {
  Controller({required this.pickFile, this.target, required this.reload});

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
    await Share.shareXFiles([XFile(target!.path)]);
  }

  void copyDesktop() {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if(home != null) target!.copy(join(home, 'Desktop', basename(target!.path)));
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

}
