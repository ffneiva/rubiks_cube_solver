import 'package:intl/intl.dart';

String formatDate(DateTime date, {bool onlyDate = false}) {
  final dateFormat =
      DateFormat(onlyDate ? 'dd/MM/yyyy' : 'dd/MM/yyyy HH:mm:ss');
  return dateFormat.format(date);
}

String getCopyright() {
  DateTime now = DateTime.now();
  return '© ${now.year} - Felipe Fonseca G. Neiva';
}

String getCopyrightLink() => 'https://github.com/ffneiva';
