class RangeFilter {
  double? minVal;
  double? maxVal;
  bool enabled = false;
  final String filterName;

  RangeFilter({required this.filterName});

  RangeFilter.fromInitialVals({required this.minVal, required this.maxVal, required this.filterName});

  bool _validateMin(String? value){
    return (enabled && value != null && value.isNotEmpty
        && double.tryParse(value) == null);
  }

  bool _validateMax(String? value){
    return (enabled && value != null && value.isNotEmpty && (double.tryParse(value) == null
        || (minVal != null && double.parse(value) < minVal!)));
  }

  bool validateAndUpdateMin(String? value){
    bool validateMin = _validateMin(value);
    if(!validateMin) {
      minVal = value == null || value.isEmpty ? null
          : double.parse(value);
    }
    return validateMin;
  }

  bool validateAndUpdateMax(String? value){
    bool validateMax = _validateMax(value);
    if(!validateMax) {
      maxVal = value == null || value.isEmpty ? null
          : double.parse(value);
    }
    return validateMax;
  }

}