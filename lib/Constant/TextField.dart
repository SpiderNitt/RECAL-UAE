import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ColorGlobal.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final Color borderColor;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText,
    this.onChanged,
    this.textEditingController,
    this.focusNode, this.borderColor,
  });
  bool isValidEmail(input) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);
}

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
//      autovalidate: (hintText=="Email" && textEditingController.text!="") ? true : false,
//      validator: (hintText=="Email" && textEditingController.text!="") ? ( (input) => isValidEmail(input) ? null : "Check your Email") : null,
      obscureText: obscureText,
      controller: textEditingController,
      cursorColor: ColorGlobal.textColor,
      focusNode:  focusNode,
      keyboardType: hintText=='Email'? TextInputType.emailAddress : null,
      style: TextStyle(
        color: ColorGlobal.textColor,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: ColorGlobal.textColor),
        focusColor: ColorGlobal.textColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: ColorGlobal.colorPrimaryDark),
        ),
        fillColor: ColorGlobal.colorTextField,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor==null ? ColorGlobal.textColor : borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: ColorGlobal.blueColor),
        ),
        labelText: hintText,
        hintStyle: TextStyle(color: ColorGlobal.colorPrimary, fontSize: 14),
        prefixIcon: Icon(
          prefixIconData,
          size: 20,
          color: ColorGlobal.textColor,
        ),
        suffixIcon: GestureDetector(
          child: Icon(
            suffixIconData,
            size: 20,
            color: ColorGlobal.textColor,
          ),
        ),
      ),
    );
  }
}
