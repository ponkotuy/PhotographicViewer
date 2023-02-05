
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DraggableImageWidget extends StatelessWidget {
  const DraggableImageWidget({super.key, required this.file, required this.child});

  final File file;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (snapshot, session) async {
        final item = DragItem(image: await snapshot());
        item.add(Formats.jpeg.lazy(() => file.readAsBytes()));
        return item;
      },
      allowedOperations: () => [DropOperation.copy, DropOperation.link],
      child: DraggableWidget(child: child)
    );
  }

}
