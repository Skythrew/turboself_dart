class TerminalPrice {
  final num id;
  final num localId;
  final String name;
  final num price;

  factory TerminalPrice.fromJSON(Map<String, dynamic> json) {
    return TerminalPrice(
      json['id'],
      json['idOrig'],
      json['lib'],
      json['prix']
    );
  }

  TerminalPrice(this.id, this.localId, this.name, this.price);
}

class Terminal {
  final num id;
  final num localId;
  final num code;
  final String name;
  final List<TerminalPrice> prices;

  factory Terminal.fromJSON(Map<String, dynamic> json) {
    return Terminal(
      json['id'],
      json['idOrig'], 
      json['code2p5'],
      json['lib'],
      [for (final rawTerminalPrice in json['prix']) TerminalPrice.fromJSON(rawTerminalPrice)]
    );
  }

  Terminal(this.id, this.localId, this.code, this.name, this.prices);
}