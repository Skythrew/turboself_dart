enum Endpoints {
  login('v1/auth/login'),
  host('v1/hotes/{}'),
  hostBalances('v1/comptes/hotes/{}/3'),
  hostCanBookEvening('v1/hotes/{}/resa-soir'),
  hostSiblings('v1/hotes/{}/freres-soeurs'),
  hostReservations('v1/reservations/hotes/{}/semaines{}'),
  hostBookMeal('v2/hotes/{}/reservations-jours'),
  hostHistorySpecific('v2/hotes/{}/historiques/{}'),
  hostHistoryGlobal('v1/historiques/hotes/{}'),
  hostLatestPayment('v2/hotes/{}/paiements-payline/latest');


  const Endpoints(this.url);
  
  final String url;
}