import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:beer_stop/domain/GlobalSettings.dart';
import 'package:beer_stop/screens/alcohol_description_screen.dart';
import 'package:beer_stop/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions/flutter_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/Alcohol.dart';
import '../navigation/navigation_root.dart';
import '../widgets/search_bar_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  static String route = '/';
}

class _HomeScreenState extends State<HomeScreen> {

  final _formKey = GlobalKey<FormState>();
  final RegExp nameRegExp = RegExp('[a-zA-Z]');

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

  Future<void> _dialogBuilder(BuildContext context, GlobalSettings settings) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("What's your name bud?", style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700
                  ),),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty || !nameRegExp.hasMatch(value)) {
                        return 'C\'mon bud don\'t be a dick';
                      }
                      return null;
                    },
                    onSaved: (value){settings.username = value!;},
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    _mostEfficientAlcohol = repository.fetchMostEfficientAlcohol();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalSettings>(builder: (context, settings, child)
    {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(settings.username == '' && settings.prefs != null) {
          _dialogBuilder(context, settings);
        }
      });
      return SafeArea(child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Text("Hi, ${settings.username}", style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.w700
              )
              ),
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
                  if (snapshot.hasData) {
                    return MostEfficientAlcoholCard(snapshot.data!.title,
                        "Cheapest way to get absolutely plastered",
                        snapshot.data!.thumbnailUrl, "images/bottle.svg", () =>
                            context.go(AlcoholDescriptionScreen
                                .createRoute(MediaQuery
                                .of(context)
                                .size
                                .width, MediaQuery
                                .of(context)
                                .size
                                .height), extra: snapshot.data)
                    );
                  } else if (snapshot.hasError) {
                    return MostEfficientAlcoholCard(
                        "Could not load data", "Tap to reload",
                        null, "images/bottle.svg", () =>
                        setState(() {
                          _mostEfficientAlcohol = repository
                              .fetchMostEfficientAlcohol();
                        }));
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 50,),
              GestureDetector(
                onTap: () =>
                {
                  (NavigationRoot.of(context)!
                      .nShell as StatefulNavigationShell).goBranch(
                      1, initialLocation: true)
                },
                child: SearchBarCustom(enabled: false),

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
                  CategoryCard(AlcoholFilters.CATEGORIES[0],
                      "images/wine_glass.svg", () {
                        context.go(
                            '${SearchScreen.route}?category=${AlcoholFilters
                                .CATEGORIES[0]}');
                      }),
                  CategoryCard(
                      AlcoholFilters.CATEGORIES[1], "images/beer_mug.svg", () {
                    context.go('${SearchScreen.route}?category=${AlcoholFilters
                        .CATEGORIES[1]}');
                  }),
                  CategoryCard(AlcoholFilters.CATEGORIES[2],
                      "images/spirit_glass.svg", () {
                        context.go(
                            '${SearchScreen.route}?category=${AlcoholFilters
                                .CATEGORIES[2]}');
                      }),
                  CategoryCard(AlcoholFilters.CATEGORIES[3],
                      "images/cooler_can.svg", () {
                        context.go(
                            '${SearchScreen.route}?category=${AlcoholFilters
                                .CATEGORIES[3]}');
                      })
                ].map((widget) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: widget,
                    )).toList(),
              )
            ].map((widget) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.5),
                  child: widget,
                )).toList(),
          )
      ));}
    );
  }
}
