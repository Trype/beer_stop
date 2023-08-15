import 'dart:convert';

import 'package:beer_stop/data/Alcohol.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSettings extends ChangeNotifier{

  String get username{
    if(prefs == null) return '';
    return prefs!.containsKey('username') ? prefs!.getString('username')! : '';
  }

  set username(String username){
    if(prefs == null) return;
    prefs!.setString('username', username);
    notifyListeners();
  }

  void _initializePrefs() async{
    prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  static final GlobalSettings _instance = GlobalSettings._internal();

  factory GlobalSettings() {
    return _instance;
  }

  GlobalSettings._internal(){
    _initializePrefs();
  }

  SharedPreferences? prefs;

  void saveLikedAlcohol(Alcohol alcohol){
    if(prefs == null) return;
    final alcoholEncode = jsonEncode(
        alcohol.toJson());
    prefs!.setString(
        alcohol.permanentId.toString(),
        alcoholEncode);
    notifyListeners();
  }

  void removeLikedAlcohol(Alcohol alcohol){
    if(prefs == null) return;
    prefs!.remove(alcohol.permanentId.toString());
    notifyListeners();
  }

  void toggleLikedAlcohol(Alcohol alcohol){
    if(isAlcoholLiked(alcohol)){
      removeLikedAlcohol(alcohol);
    }
    else{
      saveLikedAlcohol(alcohol);
    }
  }

  List<Alcohol> getLikedAlcoholList(){
    if(prefs == null) return List.empty();
    Set<String> keys = prefs!.getKeys();
    List<Alcohol> alcoholList = List.empty(growable: true);
    for(String key in keys){
      if(key == 'username') continue;
      alcoholList.add(Alcohol.fromJson(jsonDecode(prefs!.getString(key)!)));
    }
    return alcoholList;
  }

  bool isAlcoholLiked(Alcohol alcohol) => prefs?.containsKey(alcohol.permanentId.toString()) ?? false;

}