import 'dart:convert';

import 'package:beer_stop/data/Alcohol.dart';
import 'package:beer_stop/domain/GlobalSettings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions/flutter_extensions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class AlcoholDescriptionScreen extends StatefulWidget {
  const AlcoholDescriptionScreen({Key? key, required this.alcohol, required this.maxHeight, required this.maxWidth}) : super(key: key);

  final Alcohol alcohol;
  final double maxHeight;
  final double maxWidth;

  @override
  _AlcoholDescriptionScreenState createState() =>
      _AlcoholDescriptionScreenState();

  static String route = 'details/:maxWidth/:maxHeight';

  static String createRoute(double maxWidth, double maxHeight) => '/details/${maxWidth.toString()}/${maxWidth.toString()}';

}

class _AlcoholDescriptionScreenState extends State<AlcoholDescriptionScreen> with TickerProviderStateMixin{

  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(style: BorderStyle.none),
      borderRadius: BorderRadius.circular(100.0),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x66666666),
          blurRadius: 10.0,
          spreadRadius: 3.0,
          offset: Offset(0, 6.0),
        ),
      ],
    ),
    end: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.zero,
      // No shadow.
    ),
  );

  late OffsetTween offsetTween;
  late SizeTween sizeTween;

  late Animation _animation;
  late Animation _offsetAnimation;
  late Animation _sizeAnimation;

  late AnimationController _controller;


  @override
  void initState(){
    super.initState();
    sizeTween = SizeTween(begin: const Size(130, 130), end: Size(widget.maxWidth, widget.maxHeight));
    offsetTween = OffsetTween(begin: Offset(-65.0, widget.maxHeight/3.5), end: const Offset(0,0));
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = decorationTween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))..addListener(() {setState(() {

    });});
    _offsetAnimation = offsetTween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _sizeAnimation = sizeTween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Widget SmallDescription(String title, String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 5,),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  MaterialColor priceIndexColor(double priceIndex){
    if(priceIndex < 0.1){
      return Colors.green;
    }
    if(priceIndex < 0.15){
      return Colors.yellow;
    }
    return Colors.red;
  }

  Widget _createCircularImage(){
    return  Container(
      decoration: _animation.value,
      clipBehavior: Clip.hardEdge,
      width: (_sizeAnimation.value as Size).width,
      height: (_sizeAnimation.value as Size).height,
            child: widget.alcohol.imageUrl == null ? Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset("images/bottle.svg"),
            ) : CachedNetworkImage(
              imageUrl: widget.alcohol.imageUrl!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Padding(
                padding: const EdgeInsets.all(5),
                child: SvgPicture.asset("images/bottle.svg"),
              ),
              cacheManager: null,
            )
          );
    // FadeInImage(placeholder: MemoryImage(kTransparentImage), //todo handle placeholder
    //     fit: BoxFit.contain,
    //     image: NetworkImage(widget.alcohol.imageUrl!)),
  }

  Widget _createDescriptionColumn(){
    return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Text(widget.alcohol.title, style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w700
                      ), textAlign: TextAlign.center,),
                      const SizedBox(height: 20,),
                      Text(
                        widget.alcohol.brand != null ? widget.alcohol.brand! : "Generic",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      const SizedBox(height: 25,),
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: widget.alcohol.rating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SizedBox(height: 25,),
                      SmallDescription("Category", widget.alcohol.category),
                      const SizedBox(height: 25,),
                      SmallDescription("Subcategory", widget.alcohol.subcategory ?? "Generic"),
                      const SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: SmallDescription("Price", "\$${widget.alcohol.price}"),),
                          Consumer<GlobalSettings>(builder: (context, settings, child){
                            return GestureDetector(
                              onTap: () {
                                settings.toggleLikedAlcohol(widget.alcohol);
                              },
                              child: Icon(settings.isAlcoholLiked(widget.alcohol) ?  Icons.favorite : Icons.favorite_border, size: 30,
                                color: settings.isAlcoholLiked(widget.alcohol) ? Colors.red : Colors.black,),
                            );
                          }),
                          Expanded(child: SmallDescription("Volume", "${widget.alcohol.volume}mL"),)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Column(
                        children: [
                          const Text(
                            "Efficiency",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Playfair Display',
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            "${widget.alcohol.priceIndex.toStringAsFixed(3)}/mL",
                            style: TextStyle(
                                color: priceIndexColor(widget.alcohol.priceIndex),
                                fontSize: 30,
                                fontFamily: 'Playfair Display',
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25,),
                      SmallDescription("Description", widget.alcohol.description ?? "No idea. Try at your own risk"),
                      const SizedBox(height: 25,),
                    ],),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragUpdate: (details){
          if(details.delta.dx > 0 && _controller.status != AnimationStatus.forward){
            _controller.forward();
          }
          else if(details.delta.dx < 0 && _controller.status != AnimationStatus.reverse){
            _controller.reverse();
          }
        },
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
        body:  LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                _createDescriptionColumn(),
                Positioned(
                    left: (_offsetAnimation.value as Offset).dx,
                    top: (_offsetAnimation.value as Offset).dy,
                    child: _createCircularImage(),)
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
}
