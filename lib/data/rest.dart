import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ponta_firme/model/rating.dart';

class Rest{

  static final BASE_URL = "http://18.229.68.199/pontafirmeapi/";
  static final RATING_URL = BASE_URL + "rating/average/";

  Future<Rating> getRating({String cpfCnpj}) async {
    try {
      http.Response response = await http.get("${RATING_URL}${cpfCnpj.toString()}",
//          headers: await _getToken()
      );
      print("${RATING_URL}${cpfCnpj.toString()}");
      var jsonData = json.decode(response.body);
      if(response.statusCode == 200)
        return Rating.fromJson(jsonData);
    } on Exception catch (_) {}
  }
}