import 'package:mc_server_status/models/mc_server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<MinecraftServer> fetchServer(String address) async {
  var url = Uri.https("api.mcsrvstat.us", "/2/$address");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var json = convert.jsonDecode(response.body) as Map<String, dynamic>;

    return MinecraftServer.fromJson(json);
  } else {
    throw Exception("Request failed with status: ${response.statusCode}.");
  }
}
