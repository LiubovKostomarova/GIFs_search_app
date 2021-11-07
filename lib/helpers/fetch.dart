import 'dart:convert';
import 'package:http/http.dart';

class FetchHelper {
  final String url;
  FetchHelper(this.url);

  Future<dynamic> getData() async {
    Response response = await get(
        'https://api.openweathermap.org/data/2.5/weather?id=524901&appid=bcda3f7eb559e4a32713ac467c5fe5e0');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
