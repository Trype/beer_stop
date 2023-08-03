import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../data/Alcohol.dart';
import '../screens/alcohol_description_screen.dart';

class AlcoholDescriptionCard extends StatelessWidget {
  const AlcoholDescriptionCard({Key? key, required this.alcohol}) : super(key: key);

  final Alcohol alcohol;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Ink(
          decoration: ShapeDecoration(
            color: const Color(0xFFF0F0F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: InkWell(
            onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AlcoholDescriptionScreen(alcohol: alcohol, maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width,);
            }))
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: alcohol.thumbnailUrl == null ? CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset("images/bottle.svg"),
                    ),
                  ) : CachedNetworkImage(
                    imageUrl: alcohol.thumbnailUrl!,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 40,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset("images/bottle.svg"),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Column(
                  children: [
                    Text(alcohol.title, style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w700
                    ), textAlign: TextAlign.center,),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("\$${alcohol.priceIndex.toStringAsFixed(3)}/mL", style: const TextStyle(
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
              ],
            ),
          ),
        ));
  }
}
