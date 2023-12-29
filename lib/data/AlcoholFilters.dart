import 'package:beer_stop/data/Categories.dart';
import 'package:beer_stop/data/RangeFilter.dart';
import 'package:flutter/material.dart';

class AlcoholFilters {

  AlcoholFilters.fromCategory(String category){
    categorySelection.add(category);
  }

  AlcoholFilters();

  static final List<String> CATEGORIES = <String> [
    Wine.name,
    BeerCider.name,
    Spirits.name,
    Coolers.name
  ];

  List<String> categorySelection = <String> [];

  RangeFilter priceIndices = RangeFilter(filterName: "Price Index");
  RangeFilter prices = RangeFilter(filterName: "Price");
  RangeFilter volumes = RangeFilter(filterName: "Volume");
  RangeFilter alcoholContents = RangeFilter.fromInitialVals(minVal: 0, maxVal: 100, filterName: "Alcohol Content");
}