import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/ColorGlobal.dart';

class TextFieldWidget extends StatefulWidget {
   String hintText;
   IconData prefixIconData;
   IconData suffixIconData;
   bool obscureText;
   Function onChanged;
   FocusNode focusNode;
   TextEditingController textEditingController;
   Color borderColor;
   bool passwordVisible = false;
   TextFieldWidget({this.hintText,this.prefixIconData,this.suffixIconData,this.obscureText,this.passwordVisible,this.onChanged,this.textEditingController,this.borderColor,this.focusNode});

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      obscureText: !widget.passwordVisible,
      controller: widget.textEditingController,
      cursorColor: ColorGlobal.textColor,
      focusNode:  widget.focusNode,
      keyboardType: widget.hintText=='Email'? TextInputType.emailAddress : null,
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
          borderSide: BorderSide(color: widget.borderColor==null ? ColorGlobal.textColor : widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: ColorGlobal.blueColor),
        ),
        labelText: widget.hintText,
        hintStyle: TextStyle(color: ColorGlobal.colorPrimary, fontSize: 14),
        prefixIcon: Icon(
          widget.prefixIconData,
          size: 20,
          color: ColorGlobal.textColor,
        ),
        suffixIcon: widget.hintText=="Password" ? IconButton(
          icon: Icon(
            widget.passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            size: 20,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              widget.passwordVisible = !widget.passwordVisible;
            });
          },
        ) : null,
      ),
    );
  }
}


