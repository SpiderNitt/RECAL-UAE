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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: ColorGlobal.textColor,
      focusNode:  focusNode,
        controller: controller,
        keyboardType: type=='number'? TextInputType.numberWithOptions(signed: false,decimal: false) : type=='phone' ? TextInputType.phone : TextInputType.text,
        inputFormatters: type=='number' ? [WhitelistingTextInputFormatter.digitsOnly] : null ,
        decoration: InputDecoration(
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
