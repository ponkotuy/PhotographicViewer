
import 'dart:io';

import 'package:exif/exif.dart';

class ExifParser {
  static Future<String?> parseCreateDate(File file) async {
    final tags = await readExifFromBytes(file.readAsBytesSync());
    print(tags['EXIF DateTimeOriginal']?.printable);
    return tags['EXIF DateTimeOriginal']?.printable;
  }
}
