import 'package:beer_stop/data/Alcohol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';

class AlcoholDescriptionScreen extends StatefulWidget {
  const AlcoholDescriptionScreen({Key? key, required this.alcohol}) : super(key: key);

  final Alcohol alcohol;

  @override
  _AlcoholDescriptionScreenState createState() =>
      _AlcoholDescriptionScreenState();
}

class _AlcoholDescriptionScreenState extends State<AlcoholDescriptionScreen> {

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
              fontSize: 12,
              fontFamily: 'Raleway',
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
    return GestureDetector(
        onTap: () => {},
        child: ClipOval(
            child:
            FadeInImage(placeholder: MemoryImage(kTransparentImage),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                image: NetworkImage(widget.alcohol.imageUrl!)),
          ),

    );

  }

  Widget _createDescriptionColumn(){
    return Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text(widget.alcohol.title, style: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w700
                    )),
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
                          "${widget.alcohol.priceIndex}/mL",
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
                    SmallDescription("Description", widget.alcohol.description ?? "No idea. Try at your own risk")
                  ],),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
        body: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              _createDescriptionColumn(),
              Positioned(
                  left: -75,
                  top: constraints.maxHeight/3.5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _createCircularImage(),
                      // const Icon(Icons.arrow_forward_ios)
                    ],
                  ))

            ],
          ),
        )
    );
  }
}
