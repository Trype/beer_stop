import 'dart:async';

import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:flutter/material.dart';

import '../data/Alcohol.dart';

class SearchBarCustom extends StatefulWidget {
  SearchBarCustom({Key? key, this.enabled = true, this.callback, this.onFocus}) : super(key: key);

  final bool enabled;

  final AlcoholRepository repository = AlcoholRepository();

  final Function(String)? callback;

  final Function()? onFocus;
  @override
  _SearchBarCustomState createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {

  String _displayStringForOption(Alcohol option) => option.title;
  List<Alcohol> _suggested = List.empty();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Autocomplete<Alcohol>(
      optionsBuilder: (TextEditingValue textEditingValue) async{
        _suggested = await widget.repository.fetchSuggestions(textEditingValue.text);
        return _suggested.length > 5 ? _suggested.getRange(0, 5) : _suggested;
      },
      displayStringForOption: _displayStringForOption,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        focusNode.addListener(() {
          if(widget.onFocus != null) widget.onFocus!();
        });
        return  Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
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
            enabled: widget.enabled,
            onSubmitted: (String text) {
              if(widget.callback != null && text.isNotEmpty) widget.callback!(text);
            },
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12)
            ),
            width: constraints.biggest.width, // <-- Right here !
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              padding: EdgeInsets.zero,
              itemCount: options.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final Alcohol option = options.elementAt(index);
                return InkWell(
                  onTap: () => {
                    onSelected(option),
                    if(widget.callback != null) widget.callback!(option.title)
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(option.title),
                  ),
                );
              },
            ),
          ),
        ),
      ),
        )
    );
  }
}
