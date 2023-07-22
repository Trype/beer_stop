import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:beer_stop/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/Alcohol.dart';
import '../widgets/search_bar_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AlcoholRepository repository = AlcoholRepository();
  late Future<Alcohol> _mostEfficientAlcohol;

  Widget MostEfficientAlcoholCard(String heading, String subheading, String? imageUrl, String placeholder, VoidCallback? callback, {bool usePlaceholder = false}){
    return
      Container(
        width: double.infinity,
    child: Ink(
        decoration: ShapeDecoration(
            color: const Color(0xFFF0F0F0),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        ),
        ),
      child: InkWell(
        onTap: callback,
        child: Row(
          children: [
            Expanded(child: Column(
              children: [
                Text(heading, style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w700
                ), textAlign: TextAlign.center,),
                Padding(padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(subheading, style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9.5,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700
                  ), textAlign: TextAlign.center,),)
              ].map((widget) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: widget,
              )).toList(),
            )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: imageUrl == null || usePlaceholder ? CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset(placeholder),
                ),
              ) : CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SvgPicture.asset(placeholder),
                  ),
                ),
              ),
            )
            ,
          ],
        ),
      ),
    ));
  }

  Widget CategoryCard(String category, String categoryAsset, VoidCallback callback){
    return
      Container(
          width: 70,
          child: Ink(
          decoration: ShapeDecoration(
          color: const Color(0xFFF0F0F0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    ),
    child: InkWell(
    onTap: callback,
    child: Center(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 17.5),
            child: SvgPicture.asset(categoryAsset, height: 33,),),
          Padding(padding: const EdgeInsets.only(bottom: 12.5),
            child: Text(
              category,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700
              ),
            ),)
        ],
      ),
    )
    )
    )
      );
  }

  @override
  void initState(){
    super.initState();
    _mostEfficientAlcohol = repository.fetchMostEfficientAlcohol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 77.5,),
          Text("Hi, John", style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.w700
          )),
          const SizedBox(height: 20,),
          const Text(
            "Start your search below",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 30,),
          FutureBuilder<Alcohol>(
              future: _mostEfficientAlcohol,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return MostEfficientAlcoholCard(snapshot.data!.title, "Cheapest way to get absolutely plastered",
                      snapshot.data!.thumbnailUrl, "images/bottle.svg", () => {});
                } else if(snapshot.hasError){
                  return MostEfficientAlcoholCard("Could not load data", "Tap to reload",
                        null, "images/bottle.svg", () => setState(() {
                        _mostEfficientAlcohol = repository.fetchMostEfficientAlcohol();
                      }));

                }
                return const CircularProgressIndicator();
              },
          ),
          const SizedBox(height: 50,),
      GestureDetector(
        onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SearchScreen(filters: AlcoholFilters());
        }))
        },
        child: const Hero(
          tag: 'heroSearchBar',
          child: SearchBarCustom(enabled: false),
        ),
      ),
          const SizedBox(height: 30,),
          const Text(
            "Popular search categories",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryCard(AlcoholFilters.CATEGORIES[0], "images/wine_glass.svg", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen(filters: AlcoholFilters.fromCategory(AlcoholFilters.CATEGORIES[0]));
                }));
              }),
              CategoryCard(AlcoholFilters.CATEGORIES[1], "images/beer_mug.svg", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen(filters: AlcoholFilters.fromCategory(AlcoholFilters.CATEGORIES[1]));
                }));
              }),
              CategoryCard(AlcoholFilters.CATEGORIES[2], "images/spirit_glass.svg", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen(filters: AlcoholFilters.fromCategory(AlcoholFilters.CATEGORIES[2]));
                }));
              }),
              CategoryCard(AlcoholFilters.CATEGORIES[3], "images/cooler_can.svg", () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen(filters: AlcoholFilters.fromCategory(AlcoholFilters.CATEGORIES[3]));
                }));
              })
            ].map((widget) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: widget,
            )).toList(),
          )
        ].map((widget) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.5),
          child: widget,
        )).toList(),
      )
    );
  }
}
