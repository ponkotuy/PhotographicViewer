
import 'package:collection/collection.dart';
import 'package:fraction/fraction.dart';

class Exif implements Comparable<Exif>{
  Exif(this.shootingAt, this.focal, this.aperture, this.exposureTime, this.iso);

  final String? shootingAt;
  final Fraction? focal;
  final Fraction? aperture;
  final String? exposureTime;
  final String? iso;

  @override int compareTo(Exif other) {
    return (shootingAt ?? "0").compareTo(other.shootingAt ?? "0");
  }

  String printable() {
    final params = [
      (focal != null ? '${focal!.toDouble()}mm' : null),
      (aperture != null ? 'F${aperture!.toDouble()}' : null),
      (exposureTime != null ? '${exposureTime!}s' : null),
      (iso != null ? 'ISO${iso!}' : null)
    ].whereNotNull();
    return '${shootingAt != null ? '${shootingAt!} - ' : ''}${params.join(" ")}';
  }
}
