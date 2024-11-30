enum Endpoints {
  login('v1/auth/login');

  const Endpoints(this.url);
  
  final String url;
}