class Payment {
  final num? id;
  final num amount;
  final String status;
  final String token;
  final String? url;
  final String cancelURL;
  final String returnURL;
  final DateTime date;

  factory Payment.fromJSON(Map<String, dynamic> json) {
    return Payment(
        json['id'],
        json['montant'],
        json['statut'],
        json['token'],
        null,
        'https://espacenumerique.turbo-self.com/PagePaiementRefuse.aspx?token=${json['token']}',
        'https://espacenumerique.turbo-self.com/PagePaiementValide.aspx?token=${json['token']}',
        DateTime.parse(json['date']));
  }

  Payment(this.id, this.amount, this.status, this.token, this.url,
      this.cancelURL, this.returnURL, this.date);
}
