import 'api.dart';
import '../models/models.dart';
import '../routes/endpoints.dart';
import '../utils/week_range.dart';

class HostAPI extends Api {
  HostAPI(super.get, super.post);

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
}