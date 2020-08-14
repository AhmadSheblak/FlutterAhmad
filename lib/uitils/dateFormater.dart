import 'package:intl/intl.dart';

String dateFormat() {
  var now = DateTime.now();
  var formatter = DateFormat("EEE, MMM d, ''yy");
  String formatted = formatter.format(now);
  return formatted;
}
