import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get relativeShort {
    final Duration d = DateTime.now().difference(this);
    if (d.inDays > 6) return DateFormat('d MMM yyyy').format(this);
    if (d.inDays > 0) return '${d.inDays}d ago';
    if (d.inHours > 0) return '${d.inHours}h ago';
    if (d.inMinutes > 0) return '${d.inMinutes}m ago';
    return 'Just now';
  }
}
