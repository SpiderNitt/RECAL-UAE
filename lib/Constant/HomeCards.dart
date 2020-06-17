import 'package:flutter/material.dart';
import 'ColorGlobal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCards extends StatefulWidget {
  final String title;

  const HomeCards({Key key, this.title}) : super(key: key);


  @override
  _HomeCardsState createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorGlobal.color5, Colors.white.withOpacity(0.5)],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                    child: SvgPicture.asset('assets/icons/${widget.title.split(" ")[0]}.svg',
                        color: ColorGlobal.color4),
                    height: 60)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6.0),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 18.0, color:  ColorGlobal.color4),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
