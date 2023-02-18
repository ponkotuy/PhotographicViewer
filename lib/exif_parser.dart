
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:fraction/fraction.dart';
import 'package:photographic_viewer/exif.dart';

class ExifParser {
  static Future<Exif> parse(File file) async {
    final tags = await readExifFromBytes(file.readAsBytesSync());
    final shootingAt = tags['EXIF DateTimeOriginal']?.printable;
    final focalLength = tags['EXIF FocalLength'];
    final focal = focalLength == null ? null : Fraction.fromString(focalLength.printable);
    final fNumber = tags['EXIF FNumber'];
    final aperture = fNumber == null ? null : Fraction.fromString(fNumber.printable);
    final exposureTime = tags['EXIF ExposureTime']?.printable;
    final iso = tags['EXIF ISOSpeedRatings']?.printable;
    return Exif(shootingAt, focal, aperture, exposureTime, iso);
  }
}
