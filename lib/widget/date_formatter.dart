import 'package:intl/intl.dart';

String getTimeAgo(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return DateFormat('d MMM y').format(dateTime);
  } else if (difference.inHours > 0) {
    return '${difference.inHours} jam yang lalu';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} menit yang lalu';
  } else if (difference.inSeconds > 1) {
    return '${difference.inSeconds} detik yang lalu';
  }else {
    return 'Baru saja';
  }
}