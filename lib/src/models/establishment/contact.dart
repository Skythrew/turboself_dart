class Contact {
  final String? phoneNumber;
  final String? faxNumber;
  final String? email;
  final String? website;

  factory Contact.fromJSON(Map<String, dynamic> json) {
    return Contact(
        json['tel'],
        json['fax'],
        (json['configuration'] != null) ? json['configuration']['email'] : null,
        (json['configuration'] != null) ? json['configuration']['url'] : null);
  }

  factory Contact.allNull() {
    return Contact(null, null, null, null);
  }

  Contact(this.phoneNumber, this.faxNumber, this.email, this.website);
}
