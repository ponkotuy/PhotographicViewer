
import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.file}) : super(key: key);

  final File? file;

  @override
  Widget build(BuildContext context) {
    if(file == null) {
      return Text(
        'None', style: Theme.of(context).textTheme.headline4,
      );
    }
    return Expanded(
        child: Image(image: FileImage(file!),)
    );
  }
}
