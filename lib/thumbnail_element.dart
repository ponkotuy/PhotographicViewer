
import 'package:flutter/material.dart';
import 'package:photographic_viewer/util/image_file.dart';

class ThumbnailElement extends StatelessWidget {
  const ThumbnailElement({Key? key, required this.imageFile, required this.selected, required this.onTap}) : super(key: key);
  final ImageFile imageFile;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Image image = Image.file(imageFile.file, width: 240.0, height: 160.0, cacheWidth: 240, fit: BoxFit.contain,);
    if(selected) {
      return Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorLight, width: 5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: image,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: image
      )
    );
  }
}
