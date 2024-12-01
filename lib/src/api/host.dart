import 'api.dart';
import '../models/models.dart';
import '../routes/endpoints.dart';

class HostAPI extends Api {
  HostAPI(super.get, super.post);

  Future<Host> getHost(num hostId) async {
    final rawHost = await get(Endpoints.host, hostId);

    return Host.fromJSON(rawHost);
  }
}