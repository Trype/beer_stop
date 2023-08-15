import 'package:beer_stop/domain/GlobalSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/Alcohol.dart';
import '../widgets/alcohol_description_card.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  _LikedScreenState createState() => _LikedScreenState();

  static String route = '/liked';
}

class _LikedScreenState extends State<LikedScreen> {
  List<Alcohol> alcoholList = List.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GlobalSettings>(
        builder: (context, settings, child) {
          final alcoholList = settings.getLikedAlcoholList();
          return ListView.builder(
              itemCount: alcoholList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AlcoholDescriptionCard(
                      parentRoute: '/liked', alcohol: alcoholList[index]),
                );
              });
        },
      ),

      // Consumer<GlobalSettings>(
      //   builder: (context, settings, child){
      //     final alcoholList = settings.getLikedAlcoholList();
      //
      //   },
      // ),
    );
  }
}
//
