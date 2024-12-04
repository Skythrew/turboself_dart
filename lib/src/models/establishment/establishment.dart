import 'location.dart';
import 'closure.dart';
import 'contact.dart';
import 'permissions.dart';
import 'sso_configuration.dart';
import 'synchronisation.dart';

class Establishment {
  final num id;
  final String name;
  final String? currencySymbol;
  final String? code;
  final String? logoUrl;
  final String? uai;
  final String? macAddress;
  final String motd;
  final num? minMealsToCredit;
  final num? minDebtToCredit;
  final num? minAmountToCredit;
  final bool? disabled;
  final List<Closure> closures;
  final Location location;
  final Contact contact;
  final Permissions permissions;
  final SsoConfiguration? sso;
  final Synchronisation synchronisation;

  factory Establishment.fromJSON(Map<String, dynamic> json) {
    return Establishment(
        json['id'] ?? 0,
        json['nom'] ?? 'N/A',
        json['currencySymbol'],
        json['code2p5'].toString(),
        json['logoUrl'],
        json['numEtab'],
        json['pcServeur'],
        (json['configuration'] != null)
            ? json['configuration']['msgAccueil'] ?? ''
            : 'You are not logged in so you can\'t see all data',
        (json['configuration'] != null)
            ? json['configuration']['nbRepasMini'] ?? 0
            : null,
        (json['configuration'] != null)
            ? json['configuration']['creanceMini'] ?? 0
            : null,
        (json['configuration'] != null)
            ? json['configuration']['montantCreditMini'] ?? 0
            : null,
        json['desactive'] ?? false,
        (json['configuration'] != null &&
                json['configuration']['fermetures'] != null)
            ? [
                for (final rawClosure in json['configuration']['fermetures'])
                  Closure.fromJSON(rawClosure)
              ]
            : [],
        (json['id'] != null) ? Location.fromJSON(json) : Location.allNull(),
        (json['id'] != null) ? Contact.fromJSON(json) : Contact.allNull(),
        (json['id'] != null)
            ? Permissions.fromJSON(json)
            : Permissions.allNull(),
        (json['id'] != null)
            ? SsoConfiguration.fromJSON(json)
            : SsoConfiguration.allNull(),
        (json['id'] != null)
            ? Synchronisation.fromJSON(json)
            : Synchronisation.allNull());
  }

  Establishment(
      this.id,
      this.name,
      this.currencySymbol,
      this.code,
      this.logoUrl,
      this.uai,
      this.macAddress,
      this.motd,
      this.minMealsToCredit,
      this.minDebtToCredit,
      this.minAmountToCredit,
      this.disabled,
      this.closures,
      this.location,
      this.contact,
      this.permissions,
      this.sso,
      this.synchronisation);
}
