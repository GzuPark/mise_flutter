import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'mise.dart';

class MiseApi {
  final String basUrl = dotenv.env['BASE_URL'].toString();
  final String endpoint = dotenv.env['ENDPOINT'].toString();
  final String apiKey = dotenv.env['API_KEY'].toString();

  Future<List<Mise>> getMiseData(String stationName) async {
    String url = '$basUrl/$endpoint/'
        'getMsrstnAcctoRltmMesureDnsty?'
        'serviceKey=$apiKey'
        '&returnType=json'
        '&numOfRows=100'
        '&pageNo=1'
        '&stationName=${Uri.encodeQueryComponent(stationName)}'
        '&dataTerm=DAILY'
        '&ver=1.0';

    // https://stackoverflow.com/a/66473447/7703502
    // http 0.13.0 부터 compile-time type safety 향상을 위해 아래와 같이 parsing 해줘야 함
    final response = await http.get(Uri.parse(url));

    List<Mise> data = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String, dynamic>;

      for (final _res in res['response']['body']['items']) {
        final m = Mise.fromJson(_res as Map<String, dynamic>);
        data.add(m);
      }
      return data;
    } else {
      return [];
    }
  }
}
