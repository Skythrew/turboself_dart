enum Endpoints {
  login('v1/auth/login'),
  host('v1/hotes/{}'),
  hostBalances('v1/comptes/hotes/{}/3');

  const Endpoints(this.url);
  
  final String url;
}