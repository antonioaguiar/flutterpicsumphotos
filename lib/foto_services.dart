import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_app/foto_info.dart';

class FotoServices {
  Future<FotoInfo> getInfo(int id) async {
    Response resp = await get(Uri.parse("https://picsum.photos/id/$id/info"));
    if (resp.statusCode == 200) {
      return FotoInfo.fromJson(jsonDecode(resp.body));
    }

    throw Exception("Deu um erro na hora de carregar info da foto");
  }
}
