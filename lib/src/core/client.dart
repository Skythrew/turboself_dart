import 'package:format/format.dart';
import 'package:turboself_dart/src/routes/endpoints.dart';
import 'package:turboself_dart/src/models/models.dart';
import 'package:turboself_dart/src/utils/http.dart';
import 'package:turboself_dart/src/utils/week_range.dart';

/// The Turboself client managing the session.
class TurboselfClient {
  late final num hostId;
  late final num userId;
  late final String username;

  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> _get(Endpoints endpoint, [Object? opts]) {
    if (opts != null) {
      return getURL(endpoint.url.format(opts), _headers);
    } else {
      return getURL(endpoint.url, _headers);
    }
  }

  Future<dynamic> _post(Endpoints endpoint, Map<String, dynamic> body, [Object? opts]) {
    if (opts != null) {
      return postURL(endpoint.url.format(opts), body, _headers);
    } else {
      return postURL(endpoint.url, body, _headers);
    }
  }

  Future<dynamic> _put(Endpoints endpoint, Map<String, dynamic> body, [Object? opts]) {
    if (opts != null) {
      return putURL(endpoint.url.format(opts), body, _headers);
    } else {
      return putURL(endpoint.url, body, _headers);
    }
  }

  /// Logs the user in thanks to credentials.
  Future<void> login(String username, String password) async {
    final response = await _post(Endpoints.login, {'username': username, 'password': password});

    _headers['Authorization'] = 'Bearer ${response['access_token']}';

    hostId = response['hoteId'];
    userId = response['userId'];
    this.username = username;
  }

  Future<Host> getHost() async {
    final rawHost = await _get(Endpoints.host, hostId);

    return Host.fromJSON(rawHost);
  }

  Future<List<Balance>> getHostBalances() async {
    final rawBalances = await _get(Endpoints.hostBalances, hostId);

    return [for (final rawBalance in rawBalances) Balance.fromJSON(rawBalance)];
  }

  Future<bool> canBookEvening() async {
    return (await _get(Endpoints.hostCanBookEvening, hostId));
  }

  Future<List<Host>> getHostSiblings() async {
    final rawSiblings = await _get(Endpoints.hostSiblings, hostId);

    return [for (final rawSibling in rawSiblings) Host.fromJSON(rawSibling)];
  }

  Future<List<Booking>> getBookings([num? week]) async {
    final rawBookings = await _get(Endpoints.hostReservations, [hostId, (week != null ? '?num=$week' : '')]);

    if(rawBookings['rsvWebDto'].isEmpty) {
      throw Exception('No booking found for this week!');
    }

    final weekRange = getWeekRange(rawBookings['rsvWebDto'][0]['semaine'], rawBookings['rsvWebDto'][0]['annee']);

    return [for (final rawBooking in rawBookings['rsvWebDto']) Booking.fromJSON(rawBooking, weekRange)];
  }

  Future<BookingDay> bookMeal(String bookId, num day, {num reservations = 1, bool bookEvening = false}) async {
    final rawBook = await _post(Endpoints.hostBookMeal, {
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

  Future<HistoryEvent> getHistoryEvent(num eventId) async {
    final rawHistory = await _get(Endpoints.hostHistorySpecific, [hostId, eventId]);

    return HistoryEvent.fromJSON(rawHistory);
  }

  Future<List<HistoryEvent>> getHistory() async {
    final rawHistory = await _get(Endpoints.hostHistoryGlobal, hostId);

    return [for (final event in rawHistory) HistoryEvent.fromJSON(event)];
  }

  Future<Payment> getLatestPayment() async {
    final rawPayment = await _get(Endpoints.hostLatestPayment, hostId);

    return Payment.fromJSON(rawPayment);
  }

  Future<List<Establishment>> searchEstablishments(String query, {String code = '', num limit = 10}) async {
    final rawEstablishments = await _get(Endpoints.establishmentSearch, [query, code, limit]);
    
    return [for (final rawEstablishment in rawEstablishments) Establishment.fromJSON(rawEstablishment)];
  }

  Future<Establishment> getEstablishmentBy2P5(String code2p5) async {
    final rawEstablishment = await _get(Endpoints.establishmentBy2P5, code2p5);

    print(rawEstablishment);
    return Establishment.fromJSON(rawEstablishment[0]);
  }

  Future<Establishment> getEstablishmentById(num etabId) async {
    final rawEstablishment = await _get(Endpoints.establishmentById, etabId);

    return Establishment.fromJSON(rawEstablishment);
  }
}