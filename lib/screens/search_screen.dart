import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/data/RangeFilter.dart';
import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:beer_stop/widgets/alcohol_description_card.dart';
import 'package:beer_stop/widgets/filter_input_text_form_field.dart';
import 'package:beer_stop/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';

import '../data/Alcohol.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.filters}) : super(key: key);

  final AlcoholFilters filters;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AlcoholRepository repository = AlcoholRepository();
  late Future<List<Alcohol>> _listFetcher;
  List<Alcohol> _tempDisplayList = List.empty();
  bool menuToggle = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _minPriceIndexController = TextEditingController();
  TextEditingController _maxPriceIndexController = TextEditingController();

  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  TextEditingController _minVolumeController = TextEditingController();
  TextEditingController _maxVolumeController = TextEditingController();

  Widget _createFilterFormFieldRow(TextEditingController minController, TextEditingController maxController, RangeFilter range){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterInputTextFormField(
            labelText: 'Min',
            controller: minController,
            enabled: range.enabled,
            validator: (String? value) {
              return range.validateAndUpdateMin(value)
                  ? 'Nope'
                  : null;
            }),
        const SizedBox(width: 10,),
        Text(
          "-",
          style: TextStyle(
              color: range.enabled ? Colors.black : Theme.of(context).disabledColor,
              fontSize: 24,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(width: 10,),
        FilterInputTextFormField(
            labelText: 'Max',
            controller: maxController,
            enabled: range.enabled,
            validator: (String? value) {
              return range.validateAndUpdateMax(value)
                  ? 'Nope'
                  : null;
            })
      ],
    );
  }

  Widget _createFilterFormFieldHeader(RangeFilter range){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(range.filterName),
        Switch(
          value: range.enabled,
          onChanged: (value) {
            setState(() {
              _formKey.currentState!.reset();
              range.enabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _createFilterFormField(TextEditingController minController, TextEditingController maxController, RangeFilter range){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createFilterFormFieldHeader(range),
        _createFilterFormFieldRow(minController, maxController, range)
      ],
    );
  }

  Widget _createFilterRangeSlider(RangeFilter range){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createFilterFormFieldHeader(widget.filters.alcoholContents),
        RangeSlider(
          values: RangeValues(widget.filters.alcoholContents.minVal!,
              widget.filters.alcoholContents.maxVal!),
          max: 100,
          divisions: 50,
          labels: RangeLabels(
            widget.filters.alcoholContents.minVal!.round().toString(),
            widget.filters.alcoholContents.maxVal!.round().toString(),
          ),
          onChanged: widget.filters.alcoholContents.enabled ? (RangeValues values) {
            setState(() {
              widget.filters.alcoholContents.minVal = values.start;
              widget.filters.alcoholContents.maxVal = values.end;
            });
          } : null,
        )
      ],
    );

  }

  @override
  void initState() {
    super.initState();
    _listFetcher = repository.updateAlcoholList(
        filters: widget.filters, filtersChanged: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: const Icon(Icons.menu),
                        onTap: () {
                          //action code when clicked
                          setState(() {
                            menuToggle = !menuToggle;
                          });
                        },
                      ),
                      if (menuToggle)
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Categories"),
                                  ToggleButtons(
                                    direction: Axis.horizontal,
                                    onPressed: (int index) {
                                      // All buttons are selectable.
                                      setState(() {
                                        widget.filters.categorySelection[index] =
                                        !widget
                                            .filters.categorySelection[index];
                                      });
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    selectedBorderColor: Colors.green[700],
                                    selectedColor: Colors.white,
                                    fillColor: Colors.green[200],
                                    color: Colors.green[400],
                                    constraints: const BoxConstraints(
                                      minHeight: 30.0,
                                      minWidth: 60.0,
                                    ),
                                    isSelected: widget.filters.categorySelection,
                                    children: AlcoholFilters.CATEGORIES
                                        .map((e) => Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(e),
                                    ))
                                        .toList(),
                                  ),
                                  _createFilterFormField(_minPriceIndexController, _maxPriceIndexController, widget.filters.priceIndices),
                                  _createFilterFormField(_minPriceController, _maxPriceController, widget.filters.prices),
                                  _createFilterFormField(_minVolumeController, _maxVolumeController, widget.filters.volumes),
                                  _createFilterRangeSlider(widget.filters.alcoholContents),
                                  const SizedBox(height: 10,),
                                  TextButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if(_formKey.currentState!.validate()){
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          _listFetcher =
                                              repository.updateAlcoholList(
                                                  filters: widget.filters,
                                                  filtersChanged: true);
                                        }
                                      });
                                    },
                                    child: const Text('Apply Filters'),
                                  )
                                ]),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Hero(
                        tag: 'heroSearchBar',
                        child: SearchBarCustom(),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ]
                        .map((widget) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 34.5),
                              child: widget,
                            ))
                        .toList()),
              ),
              Expanded(
                  child: FutureBuilder<List<Alcohol>>(
                future: _listFetcher,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _tempDisplayList = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 34.5),
                      child: ListView.builder(
                          itemCount: _tempDisplayList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: AlcoholDescriptionCard(
                                  alcohol: _tempDisplayList[index]),
                            );
                          }),
                    );
                  }
                  // else if(snapshot.hasError){
                  //   //todo
                  // }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34.5),
                    child: ListView.builder(
                        // clipBehavior: Clip.antiAlias,
                        itemCount: _tempDisplayList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AlcoholDescriptionCard(
                                alcohol: _tempDisplayList[index]),
                          );
                        }),
                  );
                },
              )),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _minPriceIndexController.dispose();
    _maxPriceIndexController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minVolumeController.dispose();
    _maxVolumeController.dispose();
    super.dispose();
  }
}
