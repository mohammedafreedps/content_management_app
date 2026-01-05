class CalendarDetail {
  final DateTime _now = DateTime.now();

  // -----------------------------
  // Total days in current month
  // -----------------------------
  int get totalDaysInCurrentMonth {
    return DateTime(_now.year, _now.month + 1, 0).day;
  }

  // -----------------------------
  // Month details
  // Returns:
  // [
  //  {date: 1, day: "Monday", week: "Mon"},
  //  {date: 2, day: "Tuesday", week: "Tue"},
  // ]
  // -----------------------------
  List<Map<String, dynamic>> get monthDetails {
    final List<Map<String, dynamic>> data = [];

    for (int i = 1; i <= totalDaysInCurrentMonth; i++) {
      final date = DateTime(_now.year, _now.month, i);
      data.add({
        'date': i,
        'day': _dayName(date.weekday),
        'week': _weekShort(date.weekday),
      });
    }

    return data;
  }

  // -----------------------------
  // Current week (Mon → Sun)
  // Returns:
  // [
  //  {date: 18, week: "Mon"},
  //  {date: 19, week: "Tue"},
  // ]
  // -----------------------------
  List<Map<String, dynamic>> get currentWeekDetails {
    final List<Map<String, dynamic>> data = [];

    // Monday as start of week
    final monday =
        _now.subtract(Duration(days: _now.weekday - DateTime.monday));

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      data.add({
        'date': date.day,
        'week': _weekShort(date.weekday),
      });
    }

    return data;
  }

  // -----------------------------
  // Helpers
  // -----------------------------
  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _weekShort(int weekday) {
    const weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weeks[weekday - 1];
  }
}
