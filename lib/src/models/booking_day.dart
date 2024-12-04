import '../utils/week_range.dart';

class BookingDay {
  final String id;
  final bool booked;
  final bool canBook;
  final num dayNumber;
  final String? message;
  final num reservations;
  final DateTime date;

  factory BookingDay.fromJSON(
      Map<String, dynamic> json, String bookId, WeekRange weekRange) {
    return BookingDay(
        bookId,
        json['dayReserv'] > 0,
        json['autorise'],
        json['dayOfWeek'],
        json['msg'],
        json['dayReserv'],
        DateTime.fromMillisecondsSinceEpoch(
            weekRange.from.millisecondsSinceEpoch +
                (json['dayOfWeek'] - 1) * 86400000 as int));
  }

  BookingDay(this.id, this.booked, this.canBook, this.dayNumber, this.message,
      this.reservations, this.date);
}
