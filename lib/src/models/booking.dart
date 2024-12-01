import '../utils/week_range.dart';
import 'booking_day.dart';
import 'terminal.dart';

class Booking {
  final String id;
  final num week;
  final num hostId;
  final DateTime from;
  final DateTime to;
  final Terminal terminal;
  final List<BookingDay> days;

  factory Booking.fromJSON(Map<String, dynamic> json, WeekRange weekRange) {
    return Booking(
      json['id'], 
      json['semaine'],
      json['hote']['id'],
      weekRange.from,
      weekRange.to,
      Terminal.fromJSON(json['borne']),
      [for (final rawBookingDay in json['jours']) BookingDay.fromJSON(rawBookingDay, json['id'], weekRange)]
    );
  }

  Booking(this.id, this.week, this.hostId, this.from, this.to, this.terminal, this.days);  
}