import 'package:format/format.dart';
import 'package:turboself_dart/src/routes/endpoints.dart';
import 'package:turboself_dart/src/models/models.dart';
import 'package:turboself_dart/src/utils/http.dart';
import 'package:turboself_dart/src/utils/week_range.dart';

/// The Turboself client managing the session.
class TurboselfClient {
  /// Host id
  late final num hostId;

  /// User id
  late final num userId;

  /// Username (usually email)
  late final String username;

  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<dynamic> _get(Endpoints endpoint, [Object? opts]) {
    if (opts != null) {
      return getURL(endpoint.url.format(opts), _headers);
    } else {
      return getURL(endpoint.url, _headers);
    }
  }

  Future<dynamic> _post(Endpoints endpoint, Map<String, dynamic> body,
      [Object? opts]) {
    if (opts != null) {
      return postURL(endpoint.url.format(opts), body, _headers);
    } else {
      return postURL(endpoint.url, body, _headers);
    }
  }

  Future<dynamic> _put(Endpoints endpoint, Map<String, dynamic> body,
      [Object? opts]) {
    if (opts != null) {
      return putURL(endpoint.url.format(opts), body, _headers);
    } else {
      return putURL(endpoint.url, body, _headers);
    }
  }

  /// Logs the user in thanks to credentials.
  Future<void> login(String username, String password) async {
    final response = await _post(
        Endpoints.login, {'username': username, 'password': password});

    _headers['Authorization'] = 'Bearer ${response['access_token']}';

    hostId = response['hoteId'];
    userId = response['userId'];
    this.username = username;
  }

  /// Requests password reset for the account with the given email.
  Future<bool> requestPasswordReset(String email) async {
    final rawPasswordResetReq = await _get(Endpoints.passwordReset, email);

    if (rawPasswordResetReq['rejected'].length != 0) {
      throw Exception(
          'Failed to send password reset email to ${rawPasswordResetReq['rejected'].join(', ')}');
    }

    return true;
  }

  /// Edits account password
  Future<String> editPassword(String actualPassword, String password) async {
    final rawPasswordChange = await _put(Endpoints.passwordChange,
        {'id': userId, 'password': actualPassword, 'newPassword': password});

    return rawPasswordChange[0]['token'];
  }

  /// Returns complete infos about host.
  Future<Host> getHost() async {
    final rawHost = await _get(Endpoints.host, hostId);

    return Host.fromJSON(rawHost);
  }

  /// Gets host balances (amount of available money)
  Future<List<Balance>> getHostBalances() async {
    final rawBalances = await _get(Endpoints.hostBalances, hostId);

    return [for (final rawBalance in rawBalances) Balance.fromJSON(rawBalance)];
  }

  /// Returns true if host can book a lunch for the evening.
  Future<bool> canBookEvening() async {
    return (await _get(Endpoints.hostCanBookEvening, hostId));
  }

  /// Gets host siblings.
  Future<List<Host>> getHostSiblings() async {
    final rawSiblings = await _get(Endpoints.hostSiblings, hostId);

    return [for (final rawSibling in rawSiblings) Host.fromJSON(rawSibling)];
  }

  /// Gets host bookings (available and already booked ones).
  Future<List<Booking>> getBookings([num? week]) async {
    final rawBookings = await _get(Endpoints.hostReservations,
        [hostId, (week != null ? '?num=$week' : '')]);

    if (rawBookings['rsvWebDto'].isEmpty) {
      throw Exception('No booking found for this week!');
    }

    final weekRange = getWeekRange(rawBookings['rsvWebDto'][0]['semaine'],
        rawBookings['rsvWebDto'][0]['annee']);

    return [
      for (final rawBooking in rawBookings['rsvWebDto'])
        Booking.fromJSON(rawBooking, weekRange)
    ];
  }

  /// Books a specific lunch.
  /// 
  /// [bookId] is the ID of the "menu" to book.
  /// [day] is the number of the day of week (1 for Monday, 5 for Friday).
  /// [reservations] is the number of lunches to book (usually 1).
  /// [bookEvening] is the boolean indicating if we should book for the evening.
  Future<BookingDay> bookMeal(String bookId, num day,
      {num reservations = 1, bool bookEvening = false}) async {
    final rawBook = await _post(
        Endpoints.hostBookMeal,
        {
          'dayOfWeek': day,
          'dayReserv': reservations,
          'web': {'id': bookId},
          'hasHoteResaSoirActive': bookEvening
        },
        hostId);

    return BookingDay(
        rawBook['id'],
        rawBook['dayReserv'] > 0,
        true,
        rawBook['dayOfWeek'],
        rawBook['msg'],
        rawBook['dayReserv'],
        DateTime.now());
  }

  /// Gets an event from the payment/bookings history.
  Future<HistoryEvent> getHistoryEvent(num eventId) async {
    final rawHistory =
        await _get(Endpoints.hostHistorySpecific, [hostId, eventId]);

    return HistoryEvent.fromJSON(rawHistory);
  }

  /// Gets the whole history of events.
  Future<List<HistoryEvent>> getHistory() async {
    final rawHistory = await _get(Endpoints.hostHistoryGlobal, hostId);

    return [for (final event in rawHistory) HistoryEvent.fromJSON(event)];
  }

  /// Gets a specific payment.
  Future<Payment> getPayment(String paymentToken) async {
    final rawPayment = await _get(Endpoints.paymentsSpecific, paymentToken);

    return Payment.fromJSON(rawPayment);
  }

  /// Gets the latest payment.
  Future<Payment> getLatestPayment() async {
    final rawPayment = await _get(Endpoints.hostLatestPayment, hostId);

    return Payment.fromJSON(rawPayment);
  }

  /// Initializes a payment.
  Future<Payment> initPayment(num amount) async {
    final rawPaymentReq = await _post(Endpoints.initPayment, {
      'paiementPayline': {
        'hote': {
          'id': hostId
        }
      },
      'montant': amount
    }, hostId);

    return Payment(
      null,
      amount,
      'INIT',
      rawPaymentReq['token'],
      rawPaymentReq['redirectURL'],
      'https://espacenumerique.turbo-self.com/PagePaiementRefuse.aspx?token=${rawPaymentReq['token']}',
      'https://espacenumerique.turbo-self.com/PagePaiementValide.aspx?token=${rawPaymentReq['token']}',
      DateTime.now()
    );
  }

  /// Searches for an establishment.
  Future<List<Establishment>> searchEstablishments(String query,
      {String code = '', num limit = 10}) async {
    final rawEstablishments =
        await _get(Endpoints.establishmentSearch, [query, code, limit]);

    return [
      for (final rawEstablishment in rawEstablishments)
        Establishment.fromJSON(rawEstablishment)
    ];
  }

  /// Gets an establishment by its 2P5 code.
  Future<Establishment> getEstablishmentBy2P5(String code2p5) async {
    final rawEstablishment = await _get(Endpoints.establishmentBy2P5, code2p5);

    print(rawEstablishment);
    return Establishment.fromJSON(rawEstablishment[0]);
  }

  /// Gets an establishment by its id.
  Future<Establishment> getEstablishmentById(num etabId) async {
    final rawEstablishment = await _get(Endpoints.establishmentById, etabId);

    return Establishment.fromJSON(rawEstablishment);
  }
}
