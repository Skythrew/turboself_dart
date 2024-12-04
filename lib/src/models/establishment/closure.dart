class Closure {
  final num id;
  final bool canBook;
  final bool canPay;
  final DateTime from;
  final DateTime to;

  factory Closure.fromJSON(Map<String, dynamic> json) {
    return Closure(
      json['id'],
      !json['rsv'],
      !json['paiement'],
      DateTime.parse(json['du']),
      DateTime.parse(json['au'])  
    );
  }
  
  Closure(this.id, this.canBook, this.canPay, this.from, this.to);
}