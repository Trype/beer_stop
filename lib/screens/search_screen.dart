import 'package:beer_stop/data/AlcoholFilters.dart';
import 'package:beer_stop/data/RangeFilter.dart';
import 'package:beer_stop/domain/AlcoholRepository.dart';
import 'package:beer_stop/widgets/alcohol_description_card.dart';
import 'package:beer_stop/widgets/filter_input_text_form_field.dart';
import 'package:beer_stop/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/Alcohol.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();

  static String route = '/search';
}

class _SearchScreenState extends State<SearchScreen> {
  final AlcoholFilters _filters = AlcoholFilters();
  AlcoholRepository repository = AlcoholRepository();
  late Future<List<Alcohol>> _listFetcher;
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
        _createFilterFormFieldHeader(_filters.alcoholContents),
        RangeSlider(
          values: RangeValues(_filters.alcoholContents.minVal!,
              _filters.alcoholContents.maxVal!),
          max: 100,
          divisions: 50,
          labels: RangeLabels(
            _filters.alcoholContents.minVal!.round().toString(),
            _filters.alcoholContents.maxVal!.round().toString(),
          ),
          onChanged: _filters.alcoholContents.enabled
              ? (RangeValues values) {
                  setState(() {
                    _filters.alcoholContents.minVal = values.start;
                    _filters.alcoholContents.maxVal = values.end;
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
    _listFetcher =
        repository.updateAlcoholList(filters: _filters, filtersChanged: true);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          _listFetcher = repository.updateAlcoholList(
              filters: _searchNoFilters ? null : _filters,
              searchQuery: _searchQuery);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, String> queryParameters =
        GoRouterState.of(context).uri.queryParameters;
    if (queryParameters.containsKey('category')) {
      _filters.categorySelection = List.generate(
          4,
          (index) =>
              AlcoholFilters.CATEGORIES[index] == queryParameters['category']);
    }
  }

  Widget _menuColumn() {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text("Categories"),
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            // All buttons are selectable.
            setState(() {
              _filters.categorySelection[index] =
                  !_filters.categorySelection[index];
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.green[700],
          selectedColor: Colors.white,
          fillColor: Colors.green[200],
          color: Colors.green[400],
          constraints: const BoxConstraints(
            minHeight: 30.0,
            minWidth: 60.0,
          ),
          isSelected: _filters.categorySelection,
          children: AlcoholFilters.CATEGORIES
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(e),
                  ))
              .toList(),
        ),
        _createFilterFormField(_minPriceIndexController,
            _maxPriceIndexController, _filters.priceIndices),
        _createFilterFormField(
            _minPriceController, _maxPriceController, _filters.prices),
        _createFilterFormField(
            _minVolumeController, _maxVolumeController, _filters.volumes),
        _createFilterRangeSlider(_filters.alcoholContents),
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
                _listFetcher = repository.updateAlcoholList(
                    filters: _filters,
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
                _listFetcher = repository.updateAlcoholList(
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
                            _listFetcher = repository.updateAlcoholList(
                                filters: _filters,
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
            // if(!menuToggle)
            Flexible(
              flex: 1,
                child: FutureBuilder<List<Alcohol>>(
              future: _listFetcher,
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
