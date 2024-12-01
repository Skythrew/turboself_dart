class Balance {
  /// Internal identifier of the balance.
  final num id;
  /// Internal identifier of the balance's host.
  final num hostId;
  /// Label of the balance.
  final String label;
  /// Amount of the balance.
  final num amount;
  /// Estimated host account balance (taking into account future reservations and OK payments)
  final num estimatedHostAmount;
  /// Date of the estimated balance.
  final DateTime estimatedAmountDate;

  factory Balance.fromJSON(Map<String, dynamic> json) {
    final estimatedAmountMsg = json['montantEstimeMsg'].toString();

    print(estimatedAmountMsg);

    return Balance(
      int.parse(json['id']), 
      json['hote']['id'],
      json['appli']['lib'],
      json['montant'],
      json['montantEstime'],
      DateTime.parse('${estimatedAmountMsg.substring(18, estimatedAmountMsg.length).split('/').reversed.join('-')}T12:00:00')
    );
  }

  Balance(this.id, this.hostId, this.label, this.amount, this.estimatedHostAmount, this.estimatedAmountDate);
}