import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/Constant.dart';


class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  var dropdownItems=["Volunteer","Write to admin","Write to mentor","Survey"];
  var _currentItemSelected="Volunteer";

  Future<bool> _onBackPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          centerTitle: true,
          title: Text(
            'SUPPORT',
            style: GoogleFonts.lato(color: ColorGlobal.textColor),
          ),
        ),
        body: Container(
          color: Colors.white,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: width*0.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0,right: 8,),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        underline: SizedBox(),
                        items: dropdownItems.map((String dropdownmenuitem){
                          return DropdownMenuItem<String>(
                              value:dropdownmenuitem,
                              child: Container(child: Text(dropdownmenuitem,overflow:TextOverflow.ellipsis,maxLines: 1,style:TextStyle(color: Colors.black),))
                          );
                        }).toList(),
                        hint: Text(
                            "Options",
                            style:TextStyle(fontSize: 18)
                        ),
                        onChanged: (String newvalue){
                          setState(() {
                            this._currentItemSelected=newvalue;
                            switch(this._currentItemSelected){
                              case "Volunteer":{Navigator.pushNamed(context,WRITE_TO_ADMIN);break;}
                              case "Write to admin":{Navigator.pushNamed(context,WRITE_TO_ADMIN);break;}
                              case "Write to mentor":{Navigator.pushNamed(context,WRITE_MENTOR);break;}
                              default:{Navigator.pushNamed(context,MARKET_SURVEY);break;}
                            }

                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
