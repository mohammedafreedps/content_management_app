String formatCommentTime(dynamic timestamp) {
  if (timestamp == null) return '';

  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year;

  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final amPm = date.hour >= 12 ? 'PM' : 'AM';

  return '$day/$month/$year · $hour:$minute $amPm';
}
