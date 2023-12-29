import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/data/RangeFilter.dart';
import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:beer_stop/widgets/alcohol_description_card.dart';
import 'package:beer_stop/widgets/filter_input_text_form_field.dart';
import 'package:beer_stop/widgets/search_bar_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../data/Alcohol.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();

  static String route = '/search';
}

class _SearchScreenState extends State<SearchScreen> {
  AlcoholRepository repository = AlcoholRepository();
  List<Alcohol> _tempDisplayList = List.empty();
  bool menuToggle = false;
  final _formKey = GlobalKey<FormState>();
  bool _searchNoFilters = false;
  String? _searchQuery;

  TextEditingController _minPriceIndexController = TextEditingController();
  TextEditingController _maxPriceIndexController = TextEditingController();

  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  TextEditingController _minVolumeController = TextEditingController();
  TextEditingController _maxVolumeController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  Widget _createFilterFormFieldRow(TextEditingController minController,
      TextEditingController maxController, RangeFilter range) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterInputTextFormField(
            labelText: 'Min',
            controller: minController,
            enabled: range.enabled,
            validator: (String? value) {
              return range.validateAndUpdateMin(value) ? 'Nope' : null;
            }),
        const SizedBox(
          width: 10,
        ),
        Text(
          "-",
          style: TextStyle(
              color: range.enabled
                  ? Colors.black
                  : Theme.of(context).disabledColor,
              fontSize: 24,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          width: 10,
        ),
        FilterInputTextFormField(
            labelText: 'Max',
            controller: maxController,
            enabled: range.enabled,
            validator: (String? value) {
              return range.validateAndUpdateMax(value) ? 'Nope' : null;
            })
      ],
    );
  }

  Widget _createFilterFormFieldHeader(RangeFilter range) {
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

  Widget _createFilterFormField(TextEditingController minController,
      TextEditingController maxController, RangeFilter range) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createFilterFormFieldHeader(range),
        _createFilterFormFieldRow(minController, maxController, range)
      ],
    );
  }

  Widget _createFilterRangeSlider(RangeFilter range) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createFilterFormFieldHeader(repository.filters.alcoholContents),
        RangeSlider(
          values: RangeValues(repository.filters.alcoholContents.minVal!,
              repository.filters.alcoholContents.maxVal!),
          max: 100,
          divisions: 50,
          labels: RangeLabels(
            repository.filters.alcoholContents.minVal!.round().toString(),
            repository.filters.alcoholContents.maxVal!.round().toString(),
          ),
          onChanged: repository.filters.alcoholContents.enabled
              ? (RangeValues values) {
                  setState(() {
                    repository.filters.alcoholContents.minVal = values.start;
                    repository.filters.alcoholContents.maxVal = values.end;
                  });
                }
              : null,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if(!repository.isFetchingList && repository.isListEmpty()) repository.updateAlcoholList(filters: repository.filters, filtersChanged: true);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
         repository.updateAlcoholList(
              filters: _searchNoFilters ? null : repository.filters,
              searchQuery: _searchQuery);
        });
      }
    });
  }

  Widget _menuColumn() {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text("Categories"),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 34.5),
        child: MultiSelectDialogField(
          buttonText: Text(switch(repository.filters.categorySelection.length){
            0 || 4 => "All categories selected",
            1 => "1 category selected",
            _ => "${repository.filters.categorySelection.length} categories selected"
          }),
          items: AlcoholFilters.CATEGORIES.map((e) => MultiSelectItem(e, e)).toList(),
          listType: MultiSelectListType.CHIP,
          onConfirm: (values) {
            repository.filters.categorySelection = values;
          },
          initialValue: repository.filters.categorySelection,
        ),),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        _createFilterFormField(_minPriceIndexController,
            _maxPriceIndexController, repository.filters.priceIndices),
    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        _createFilterFormField(
            _minPriceController, _maxPriceController, repository.filters.prices),
    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        _createFilterFormField(
            _minVolumeController, _maxVolumeController, repository.filters.volumes),
    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        _createFilterRangeSlider(repository.filters.alcoholContents),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            setState(() {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(FocusNode());
                // menuToggle = false;
                _searchNoFilters = false;
                repository.updateAlcoholList(
                    filters: repository.filters,
                    filtersChanged: true,
                    searchQuery: _searchQuery);
                _scrollController
                    .jumpTo(_scrollController.position.minScrollExtent);
                menuToggle = false;
              }
            });
          },
          child: const Text('Apply Filters'),
        )
      ]),
    );
  }
  
  Widget _searchFunctionality(){
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppBar().preferredSize.height + 30,
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
          const SizedBox(
            height: 20,
          ),
          if (menuToggle)
            Expanded(child: SingleChildScrollView(
              child: _menuColumn(),
            )),
          SearchBarCustom(
            callback: (String searchQuery) {
              setState(() {
                _searchQuery = searchQuery;
                _searchNoFilters = true;
               repository.updateAlcoholList(
                    filtersChanged: true, searchQuery: _searchQuery);
                _scrollController
                    .jumpTo(_scrollController.position.minScrollExtent);
                menuToggle = false;
              });
            },
            onFocus: () => setState(() {
              menuToggle = false;
            }),
          ),
          if (_searchQuery != null)
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text('Searching for: $_searchQuery', style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700
                      ),),
                      const SizedBox(width: 10,),
                      InkWell(
                        child: const Icon(Icons.cancel_outlined),
                        onTap: () {
                          //action code when clicked
                          setState(() {
                            _searchQuery = null;
                            repository.updateAlcoholList(
                                filters: repository.filters,
                                filtersChanged: true);
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          const SizedBox(
            height: 20,
          )
        ].map((widget) =>
        widget is Expanded ? widget : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.5),
          child: widget,
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           menuToggle ? Flexible(
             flex: 5,
             child: _searchFunctionality()
           ) : _searchFunctionality(),
            Flexible(
              flex: 1,
                child: FutureBuilder<List<Alcohol>>(
              future: repository.listFetcher,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _tempDisplayList = snapshot.data!;
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 34.5, vertical: 0),
                        itemCount: _tempDisplayList.length,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AlcoholDescriptionCard(
                                parentRoute: '/search',
                                alcohol: _tempDisplayList[index]),
                          );
                        });
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.5),
                  child: ListView.builder(
                      itemCount: _tempDisplayList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AlcoholDescriptionCard(
                              parentRoute: '/search',
                              alcohol: _tempDisplayList[index]),
                        );
                      }),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minPriceIndexController.dispose();
    _maxPriceIndexController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minVolumeController.dispose();
    _maxVolumeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
