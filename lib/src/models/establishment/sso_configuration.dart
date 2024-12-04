class SsoConfiguration {
  final num? id;
  final String? entCode;
  final String? entName;
  final String? casServer;
  final String? service;

  factory SsoConfiguration.fromJSON(Map<String, dynamic> json) {
    if (json['configuration'] == null || json['configuration']['sso'] == null) {
      return SsoConfiguration.allNull();
    }

    return SsoConfiguration(
      json['configuration']['sso']['id'],
      json['configuration']['sso']['entCode'],
      json['configuration']['sso']['entName'],
      json['configuration']['sso']['serveurCas'],
      json['configuration']['sso']['service']
    );
  }

  factory SsoConfiguration.allNull() {
    return SsoConfiguration(null, null, null, null, null);
  }

  SsoConfiguration(this.id, this.entCode, this.entName, this.casServer, this.service);
}