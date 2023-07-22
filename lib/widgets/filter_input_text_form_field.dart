import 'package:flutter/material.dart';

class FilterInputTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool enabled;

  const FilterInputTextFormField({Key? key, required this.labelText, required this.validator, required this.controller, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        // height: 50,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: TextStyle(
              color: enabled ? Colors.black : Theme.of(context).disabledColor,
              fontSize: 15,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700),
          validator: validator,
        ));
  }
}
