
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'image_file.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.file}) : super(key: key);

  final ImageFile? file;

  @override
  Widget build(BuildContext context) {
    if(file == null) {
      return Text('None', style: Theme.of(context).textTheme.headlineMedium);
    }
    final title = '${basename(file!.file.path)} - ${file!.exif.printable()}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Image(image: FileImage(file!.file), fit: BoxFit.contain,)),
              Text(title, style: Theme.of(context).textTheme.bodySmall),
            ]
          )
        )
      ]
    );
  }
}
