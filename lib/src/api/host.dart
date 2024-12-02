import 'api.dart';
import '../models/models.dart';
import '../routes/endpoints.dart';
import '../utils/week_range.dart';

class HostAPI extends Api {
  HostAPI(super.get, super.post, super.put);

  Future<Host> getHost(num hostId) async {
    final rawHost = await get(Endpoints.host, hostId);

    return Host.fromJSON(rawHost);
  }

  Future<List<Balance>> getHostBalances(num hostId) async {
    final rawBalances = await get(Endpoints.hostBalances, hostId);

    return [for (final rawBalance in rawBalances) Balance.fromJSON(rawBalance)];
  }

  Future<bool> canBookEvening(num hostId) async {
    return (await get(Endpoints.hostCanBookEvening, hostId));
  }

  Future<List<Host>> getHostSiblings(num hostId) async {
    final rawSiblings = await get(Endpoints.hostSiblings, hostId);

    return [for (final rawSibling in rawSiblings) Host.fromJSON(rawSibling)];
  }

  Future<List<Booking>> getBookings(num hostId, [num? week]) async {
    final rawBookings = await get(Endpoints.hostReservations, [hostId, (week != null ? '?num=$week' : '')]);

    if(rawBookings['rsvWebDto'].isEmpty) {
      throw Exception('No booking found for this week!');
    }

    final weekRange = getWeekRange(rawBookings['rsvWebDto'][0]['semaine'], rawBookings['rsvWebDto'][0]['annee']);

    return [for (final rawBooking in rawBookings['rsvWebDto']) Booking.fromJSON(rawBooking, weekRange)];
  }

  Future<BookingDay> bookMeal(num hostId, String bookId, num day, {num reservations = 1, bool bookEvening = false}) async {
    final rawBook = await post(Endpoints.hostBookMeal, {
      'dayOfWeek': day,
      'dayReserv': reservations,
      'web': {
        'id': bookId
      },
      'hasHoteResaSoirActive': bookEvening
    }, hostId);

    return BookingDay(
      rawBook['id'],
      rawBook['dayReserv'] > 0,
      true,
      rawBook['dayOfWeek'],
      rawBook['msg'],
      rawBook['dayReserv'],
      DateTime.now()
    );
  }

  Future<HistoryEvent> getHistoryEvent(num hostId, num eventId) async {
    final rawHistory = await get(Endpoints.hostHistorySpecific, [hostId, eventId]);

    return HistoryEvent.fromJSON(rawHistory);
  }

  Future<List<HistoryEvent>> getHistory(num hostId) async {
    final rawHistory = await get(Endpoints.hostHistoryGlobal, hostId);

    return [for (final event in rawHistory) HistoryEvent.fromJSON(event)];
  }
}