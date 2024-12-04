class Permissions {
  final num? maxReservationsStudentMoney;
  final num? maxReservationsStudentPackage;
  final num? maxReservationsCommensalMoney;
  final num? maxReservationsCommensalPackage;
  final num? maxReservationsTraineeMoney;
  final num? maxReservationsTraineePackage;
  final bool? qrCodeStudent;
  final bool? qrCodeCommensal;
  final bool? qrCodeTrainee;
  final bool? hideHistory;

  factory Permissions.fromJSON(Map<String, dynamic> json) {
    return Permissions(
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiElvArg']
            : null,
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiElvFor']
            : null,
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiComArg']
            : null,
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiComFor']
            : null,
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiStgArg']
            : null,
        (json['configurationSelf'] != null)
            ? json['configurationSelf']['nbmultiStgFor']
            : null,
        (json['configuration'] != null)
            ? json['configuration']['autoriseQrCodeEleve']
            : null,
        (json['configuration'] != null)
            ? json['configuration']['autoriseQrCodeCommensal']
            : null,
        (json['configuration'] != null)
            ? json['configuration']['autoriseQrCodeStagiaire']
            : null,
        (json['configuration'] != null)
            ? json['configuration']['cacherHistorique']
            : null);
  }

  factory Permissions.allNull() {
    return Permissions(
        null, null, null, null, null, null, null, null, null, null);
  }

  Permissions(
      this.maxReservationsStudentMoney,
      this.maxReservationsStudentPackage,
      this.maxReservationsCommensalMoney,
      this.maxReservationsCommensalPackage,
      this.maxReservationsTraineeMoney,
      this.maxReservationsTraineePackage,
      this.qrCodeStudent,
      this.qrCodeCommensal,
      this.qrCodeTrainee,
      this.hideHistory);
}
