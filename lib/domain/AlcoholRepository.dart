import 'package:beer_stop/data/AlcoholData.dart';
import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/domain/QueryBuilder.dart';
import 'package:beer_stop/network/AlcoholNetwork.dart';

import '../data/Alcohol.dart';

class AlcoholRepository {
  static final AlcoholRepository _instance = AlcoholRepository._internal();

  static final AlcoholNetwork alcoholApi = AlcoholNetwork(); //TODO use dependency injection

  final List<Alcohol> _displayList = List.empty(growable: true);

  late Future<List<Alcohol>> listFetcher;
  final AlcoholFilters filters = AlcoholFilters();
  bool isFetchingList = false;

  int _page = 1;
  int? lastPage;

  factory AlcoholRepository() {
    return _instance;
  }

  AlcoholRepository._internal();

  Future<Alcohol> fetchMostEfficientAlcohol() async{
    try{
      AlcoholData data = await alcoholApi.fetchAlcohols(AlcoholNetwork.base_url);
      return data.alcohols.first;
    } on Exception catch(e) {
        throw Exception(e);
    }
  }

  void updateAlcoholList({AlcoholFilters? filters, bool filtersChanged = false, String? searchQuery}) async{
    isFetchingList = true;
    listFetcher = _updateAlcoholList(filters: filters, filtersChanged: filtersChanged, searchQuery: searchQuery).whenComplete(() => isFetchingList = false);
  }

  void loadAlcoholListWithCategory(String category) async{
    isFetchingList = true;
    filters.categorySelection = [category];
    listFetcher = _updateAlcoholList(filters: filters, filtersChanged: true).whenComplete(() => isFetchingList = false);
  }

  Future<List<Alcohol>> _updateAlcoholList({AlcoholFilters? filters, bool filtersChanged = false, String? searchQuery}) async{
    if(lastPage != null && _page > lastPage! && !filtersChanged) return Future.value(_displayList);
    try{
      if(filtersChanged) {
        _displayList.clear();
        _page = 1;
        lastPage = null;
      }
      AlcoholData data = await alcoholApi.fetchAlcohols(buildQuery(filters, searchQuery, _page));
      List<Alcohol> efficientAlcohols = data.alcohols;
      lastPage = data.lastPage;
        _displayList.addAll(efficientAlcohols);
        _page++;
        return _displayList;
    } on Exception {
      return _displayList;
    }
  }

  Future<List<Alcohol>> fetchSuggestions(String query) async{
    try{
      AlcoholData data = await alcoholApi.fetchAlcohols(buildQuery(null, query, 1));
      List<Alcohol> efficientAlcohols = data.alcohols;
      return efficientAlcohols;
    } on Exception {
      return List.empty();
    }
  }

  bool isListEmpty() {
    return _displayList.isEmpty;
  }
}