enum Endpoints {
  login('v1/auth/login'),
  host('v1/hotes/{}');

  const Endpoints(this.url);
  
  final String url;
}