int parseJsonInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}

double? parseJsonDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}

DateTime parseJsonDate(dynamic value) {
  if (value is DateTime) return value.toLocal();
  return DateTime.parse(value.toString()).toLocal();
}

String? parseJsonString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}
