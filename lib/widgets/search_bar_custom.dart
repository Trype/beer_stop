import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {


  const SearchBarCustom({Key? key, this.enabled = true}) : super(key: key);

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return  Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 40,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.black,),
            contentPadding: const EdgeInsets.all(0),
            labelText: "Search",
            labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          enabled: enabled,
        ),
      ),
    );
  }
}
