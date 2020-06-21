import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ColorGlobal.dart';

class ShowDetailTextWidget extends StatelessWidget {
  final String hintText;
  final String name;
  final TextEditingController controller;
  final Function onChanged;
  final FocusNode focusNode;
  final Color color;
  final String type;


  ShowDetailTextWidget({
    this.hintText,
    this.name,
    this.onChanged,
    this.focusNode,
    this.color, this.controller, this.type,
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
      cursorColor: ColorGlobal.textColor,
      focusNode:  focusNode,
//      autovalidate: hintText=="Email" && controller.text!=""  ?  true : false,
//      validator: hintText=="Email" && controller.text!="" ?  (input) => isValidEmail(input) ? null : "Check your email" : null,
        controller: controller,
        keyboardType: type=='number'? TextInputType.numberWithOptions(signed: false,decimal: false) : type=='phone' ? TextInputType.phone : TextInputType.text,
        inputFormatters: type=='number' ? [WhitelistingTextInputFormatter.digitsOnly] : null ,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),   //  <- you can it to 0.0 for no space
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelText: controller.text!="" ? hintText : hintText+"*",
          labelStyle: TextStyle(color: controller.text!=""? ColorGlobal.blueColor : Colors.red),
        ),
    );
  }
}
