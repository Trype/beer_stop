import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/network/AlcoholNetwork.dart';

String buildQuery(AlcoholFilters? filters, String? searchQuery, int page){
  String query = AlcoholNetwork.base_url;
  if(searchQuery != null) query += "&search=${_encodeUrl(searchQuery)}";
  if(filters == null) return query;
  // filters.categorySelection.asMap().forEach((i, selected) {
  //   if(selected) {
  //     String formattedCategory = AlcoholFilters.CATEGORIES[i].replaceAll("&", "%26");
  //     query += "&category[]=$formattedCategory";
  //   }
  //   }); //TODO add back after ryan's fix
  if(filters.priceIndices.minVal != null && filters.priceIndices.enabled) query += "&minPriceIndex=${filters.priceIndices.minVal}";
  if(filters.priceIndices.maxVal != null && filters.priceIndices.enabled) query += "&maxPriceIndex=${filters.priceIndices.maxVal}";
  if(filters.prices.minVal != null && filters.prices.enabled) query += "&minPrice=${filters.prices.minVal}";
  if(filters.prices.maxVal != null && filters.prices.enabled) query += "&maxPrice=${filters.prices.maxVal}";
  if(filters.volumes.minVal != null && filters.volumes.enabled) query += "&minVolume=${filters.volumes.minVal}";
  if(filters.volumes.maxVal != null && filters.volumes.enabled) query += "&maxVolume=${filters.volumes.maxVal}";
  if(filters.alcoholContents.enabled) query += "&minVolume=${filters.volumes.minVal}&maxVolume=${filters.volumes.maxVal}";
  query += "&page=$page";
  return query;
}

String _encodeUrl(String query){
  String encoded = query.replaceAll("&", "%26");
  encoded = encoded.replaceAll("’", "%27");
  return encoded;
}