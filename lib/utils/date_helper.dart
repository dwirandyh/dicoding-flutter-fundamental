import 'package:intl/intl.dart';

class DateHelper {
  static DateTime alarmSpecificTime(String hours, String seconds) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('y/M/d');
    String timeSpecific = "$hours:$seconds:00";

    final todayDate = dateFormat.format(now);
    final today = "$todayDate $timeSpecific";
    var todayDateTime = formatDateTime(today);

    var formatted = todayDateTime.add(const Duration(days: 1));
    final tomorrowDate = dateFormat.format(formatted);
    final tomorrow = "$tomorrowDate $timeSpecific";
    var tomorrowDateTime = formatDateTime(tomorrow);

    return now.isAfter(todayDateTime) ? tomorrowDateTime : todayDateTime;
  }

  static DateTime formatDateTime(String dateTimeString) {
    DateFormat completeFormat = DateFormat('y/M/d H:m:s');
    return completeFormat.parseStrict(dateTimeString);
  }
}
