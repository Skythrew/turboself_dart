enum Endpoints {
  login('v1/auth/login'),
  host('v1/hotes/{}'),
  hostBalances('v1/comptes/hotes/{}/3'),
  hostCanBookEvening('v1/hotes/{}/resa-soir'),
  hostSiblings('v1/hotes/{}/freres-soeurs');

  const Endpoints(this.url);
  
  final String url;
}