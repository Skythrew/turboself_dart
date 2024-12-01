class WeekRange {
  final DateTime from;
  final DateTime to;

  WeekRange(this.from, this.to);
}

WeekRange getWeekRange(int weekNumber, int year) {
  weekNumber -= 2;
  final DateTime firstDayOfYear = DateTime(year);
  final int dayOfWeek = firstDayOfYear.weekday;
  final int daysToFirstMonday = 8 - dayOfWeek;
  final DateTime firstMonday = firstDayOfYear.add(Duration(days: daysToFirstMonday));
  final DateTime weekStartDate = firstMonday.add(Duration(days: weekNumber * 7));
  final DateTime weekEndDate = weekStartDate.add(Duration(days: 6));
  final DateTime weekStartDateMidnight = weekStartDate.copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);
  final DateTime weekEndDateMidnight = weekEndDate.copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);

  return WeekRange(weekStartDateMidnight.toLocal(), weekEndDateMidnight.toLocal()); 
}