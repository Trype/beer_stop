import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/domain/QueryBuilder.dart';
import 'package:beer_stop/network/AlcoholNetwork.dart';

import '../data/Alcohol.dart';

class AlcoholRepository {
  static final AlcoholRepository _instance = AlcoholRepository._internal();

  static final AlcoholNetwork alcoholApi = AlcoholNetwork(); //TODO use dependency injection

  static final List<Alcohol> _displayList = List.empty(growable: true);

  factory AlcoholRepository() {
    return _instance;
  }

  AlcoholRepository._internal();

  Future<Alcohol> fetchMostEfficientAlcohol() async{
    try{
      List<Alcohol> efficientAlcohols = await alcoholApi.fetchAlcohols(AlcoholNetwork.base_url);
      return efficientAlcohols.first;
    } on Exception catch(e) {
        throw Exception(e);
    }
  }

  Future<List<Alcohol>> updateAlcoholList({AlcoholFilters? filters, bool filtersChanged = false}) async{
    try{
      List<Alcohol> efficientAlcohols = await alcoholApi.fetchAlcohols(buildQuery(filters));
      if(filtersChanged) _displayList.clear();
      _displayList.addAll(efficientAlcohols);
      return _displayList;
    } on Exception {
      throw Exception(_displayList);
    }
  }
}