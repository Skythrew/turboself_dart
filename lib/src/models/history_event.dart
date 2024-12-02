class HistoryEvent {
  final num id;
  final DateTime date;
  final String label;
  final num amount;

  factory HistoryEvent.fromJSON(Map<String, dynamic> json) {
    return HistoryEvent(
      json['id'],
      DateTime.parse(json['date']),
      json['detail'],
      (json['credit'] ?? 0) - (json['debit'] ?? 0)
    );
  }

  HistoryEvent(this.id, this.date, this.label, this.amount);
}