
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
    this.shortcutKey
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Icon icon;
  final Text text;
  final Color color;
  final String? shortcutKey;

  @override
  Widget build(BuildContext context) {
    final shortcutLabel = shortcutKey == null ? const SizedBox.shrink() : Flexible(
        child: Text("(${shortcutKey!})",)
    );
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: color),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Flexible(child: text),
          const SizedBox(width: 4),
          shortcutLabel
        ],
      )
    );
  }
}
