import '../routes/endpoints.dart';

class Api {
  final dynamic Function(Endpoints, Object) get;
  final dynamic Function(Endpoints, Map<String, dynamic>, [Object?]) post;
  final dynamic Function(Endpoints, Map<String, dynamic>, [Object?]) put;

  Api(this.get, this.post, this.put);
}