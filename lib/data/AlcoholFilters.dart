import 'package:beer_stop/data/RangeFilter.dart';
import 'package:flutter/material.dart';

class AlcoholFilters {

  AlcoholFilters.fromCategory(String category){
    categorySelection = List.generate(4, (index) => CATEGORIES[index] == category);
  }

  AlcoholFilters();

  static final List<String> CATEGORIES = <String> [
    "Wine",
    "Beer & Cider",
    "Spirits",
    "Coolers"
  ];

  List<bool> categorySelection = <bool> [
    true,
    true,
    true,
    true
  ];

  RangeFilter priceIndices = RangeFilter(filterName: "Price Index");
  RangeFilter prices = RangeFilter(filterName: "Price");
  RangeFilter volumes = RangeFilter(filterName: "Volume");
  RangeFilter alcoholContents = RangeFilter.fromInitialVals(minVal: 0, maxVal: 100, filterName: "Alcohol Content");
}