class Location {
  final String? city;
  final String? address;
  final String? postCode;

  factory Location.fromJSON(Map<String, dynamic> json) {
    return Location(
      json['ville'],
      '${json['adr1']} ${json['adr2']}',
      json['cp']
    );
  }
  
  factory Location.allNull() {
    return Location(null, null, null);
  }
  
  Location(this.city, this.address, this.postCode);
}