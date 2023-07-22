import 'dart:convert';

import '../data/Alcohol.dart';
import 'package:http/http.dart' as http;

class AlcoholNetwork {
  static final AlcoholNetwork _instance = AlcoholNetwork._internal();

  static const String base_url = "http://68.183.108.111/api/alcohol?sortAsc=price_index";

  static final int _page = 1;

  factory AlcoholNetwork() {
    return _instance;
  }

  AlcoholNetwork._internal();

  Future<List<Alcohol>> fetchAlcohols(String queryString) async {
    print(queryString);
    final response = await http
        .get(Uri.parse(queryString));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable i = jsonDecode(response.body)['data'];
      List<Alcohol> alcohols = List.empty(growable: true);
      for(var alcohol in i){
        alcohols.add(Alcohol.fromJson(alcohol));
      }
      return alcohols;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load alcohols');
    }
  }
}