enum HostMode {
  perLunch,
  subscription
}

class HostPerms {
  final bool? payment;
  final bool? reservation;
  final bool? cafeteria;
  final bool? bookWithNegativeBalance;
  final num? maxPassages;

  factory HostPerms.fromJSON(Map<String, dynamic> json) {
    return HostPerms(
      json['droitPaiement'],
      json['droitReservation'],
      json['droitCafeteria'],
      json['autoriseReservSoldeIns'],
      json['nbMulti']
    );
  }

  HostPerms(this.payment, this.reservation, this.cafeteria, this.bookWithNegativeBalance, this.maxPassages);
}

class Host {
  final num id;
  final num localId;
  final num etabId;
  final String firstName;
  final String lastName;
  final HostMode mode;
  final String quality;
  final String division;
  final num lunchPrice;
  final num type;
  final num cardNumber;
  final String? cafeteriaUrl;
  final HostPerms permissions;

  factory Host.fromJSON(Map<String, dynamic> json) {
    return Host(
      json['id'],
      json['idOrig'],
      json['etab']['id'],
      json['prenom'],
      json['nom'],
      (json['mode'] == 'Argent') ? HostMode.perLunch : HostMode.subscription,
      json['qualite'],
      json['division'],
      json['prixDej'],
      json['type'],
      json['carteCodee'],
      json['urlCafeteria'],
      HostPerms.fromJSON(json)
    );
  }

  Host(this.id, this.localId, this.etabId, this.firstName, this.lastName, this.mode, this.quality, this.division, this.lunchPrice, this.type, this.cardNumber, this.cafeteriaUrl, this.permissions);
}