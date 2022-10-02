
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.file}) : super(key: key);

  final File? file;

  @override
  Widget build(BuildContext context) {
    if(file == null) {
      return Text('None', style: Theme.of(context).textTheme.headline4,);
    }
    final fname = basename(file!.path);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Image(image: FileImage(file!), fit: BoxFit.contain,)),
              Text(fname, style: Theme.of(context).textTheme.caption),
            ]
          )
        )
      ]
    );
  }
}
