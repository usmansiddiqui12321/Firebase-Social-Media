import 'package:firebasesocialmediaapp/res/color.dart';
import 'package:flutter/material.dart';

//focused Border => when Selected to Enter Data
//Enabled Border => Displayed without Selected

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.keyboardType,
    this.inputAction,
    this.label,
    required this.hint,
    required this.validator,
    this.isObscure = false,
    this.isCaptalized = false,
    this.maxlines = 1,
    this.islabelEnabled = false,
    this.enabledBorderColor = Colors.white,
    this.hintColor = Colors.black,
    this.helperText = "",
    this.prefixIcon,
    required this.onChanged,
    this.initialvalue,
    required this.onFieldSubmitted,
  });
  final TextEditingController controller;
  final String? helperText;
  final Color hintColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? inputAction;
  final String? label, initialvalue;
  final String hint;
  final Function(String value) validator;
  final Function(String value) onChanged;
  final Function(String value) onFieldSubmitted;

  final bool isObscure;
  final bool isCaptalized;
  final int maxlines;
  final bool islabelEnabled;
  final Color enabledBorderColor;
  final IconData? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxlines,
      initialValue: initialvalue,
      keyboardType: keyboardType,
      
      obscureText: isObscure,
      textCapitalization:
          isCaptalized ? TextCapitalization.words : TextCapitalization.none,
      textInputAction: inputAction,
      onChanged: (value) => onChanged(value),
      cursorColor: Colors.white,
      validator: (value) => validator(value!),
      onFieldSubmitted: (value) => onFieldSubmitted(value),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        // helperText: helperText,
        // prefixIcon: Icon(prefixIcon),
        labelText: islabelEnabled ? label : null,
        
        labelStyle: const TextStyle(color: Colors.black),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        errorStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: AppColors.textFieldDefaultFocus, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.secondaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: AppColors.textFieldDefaultBorderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.alertColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.alertColor, width: 2),
        ),
      ),
    );
  }
}
