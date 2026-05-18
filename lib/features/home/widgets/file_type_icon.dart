import 'package:flutter/material.dart';

import '../../../models/file_type.dart';

class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon({super.key, required this.type, required this.extension});

  final FileType type;
  final String extension;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        _shortLabel(extension),
        style: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _shortLabel(String ext) {
    final String upper = ext.toUpperCase();
    if (upper.length <= 4) return upper;
    return upper.substring(0, 4);
  }
}
