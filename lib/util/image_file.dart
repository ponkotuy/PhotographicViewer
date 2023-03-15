import 'dart:io';

import '../exif.dart';

class ImageFile implements Comparable<ImageFile> {
  ImageFile(this.file, this.exif);

  final File file;
  final Exif exif;

  @override int compareTo(ImageFile other) {
    return exif.compareTo(other.exif);
  }
}
