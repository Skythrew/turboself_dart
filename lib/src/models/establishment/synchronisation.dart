class Synchronisation {
  final DateTime? firstSync;
  final DateTime? lastSync;

  factory Synchronisation.fromJSON(Map<String, dynamic> json) {
    return Synchronisation(
      DateTime.parse(json['datePremSynchro']),
      DateTime.parse(json['dateDernSynchro'])
    );
  }
  
  factory Synchronisation.allNull() {
    return Synchronisation(null, null);
  }
  
  Synchronisation(this.firstSync, this.lastSync);
}