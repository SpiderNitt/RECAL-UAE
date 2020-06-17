import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';
import '../Constant/ColorGlobal.dart';

const List<String> images = [
  "assets/images/spiderlogo.png",
  "assets/images/spiderlogo.png",
  "assets/images/nitt_logo.png",
  "assets/images/spiderlogo.png",
  "assets/images/spiderlogo.png",
];

const List<String> companies = [
  "Image",
  "Spider Logo",
  "NITT Logo",
  "Video",
  "Loading",
];

class Sponsors extends StatefulWidget {
  @override
  SponsorState createState() {
    return new SponsorState();
  }
}

class SponsorState extends State<Sponsors> {
  var top = FractionalOffset.topCenter;
  var bottom = FractionalOffset.bottomCenter;
  int _itemCount;
  bool _loop;
  bool _autoplay;
  int _autoplayDely;
  double _padding;
  bool _outer;
  double _radius;
  double _viewportFraction;
  SwiperLayout _layout;
  int _currentIndex;
  double _scale;
  Axis _scrollDirection;
  Curve _curve;
  double _fade;
  bool _autoplayDisableOnInteraction;
  CustomLayoutOption customLayoutOption;

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  Widget _buildItem(BuildContext context, int index) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width*0.75,
            child: new Image.asset(
              images[index % images.length],
              fit: BoxFit.scaleDown,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white, //                   <--- border width here
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
              ),
            )
        ),
        Container(
            height: MediaQuery.of(context).size.height*0.07,
            width: MediaQuery.of(context).size.width*0.75,
            child: new Text(
              companies[index % images.length],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: CupertinoIcons.iconFont,
                color: Colors.black,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white, //                   <--- border width here
              ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22.0),
                bottomRight: Radius.circular(22.0),
              ),
            )
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(Sponsors oldWidget) {
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
        .addRotate([-45.0 / 180, 0.0, 45.0 / 180]).addTranslate([
      new Offset(-350.0, -40.0),
      new Offset(0.0, 0.0),
      new Offset(350.0, -40.0)
    ]);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    customLayoutOption = new CustomLayoutOption(startIndex: -1, stateCount: 3)
        .addRotate([-25.0 / 180, 0.0, 25.0 / 180]).addTranslate([
      new Offset(-370.0, 0.0),
      new Offset(0.0, 0.0),
      new Offset(370.0, 0.0)
    ]);
    _fade = 1.0;
    _currentIndex = 0;
    _curve = Curves.decelerate;
    _scale = 0.1;
    _controller = new SwiperController();
    _layout = SwiperLayout.STACK;
    _radius = 10.0;
    _padding = 0.0;
    _loop = true;
    _itemCount = 5;
    _autoplay = false;
    _autoplayDely = 3000;
    _viewportFraction = 0.5;
    _outer = false;
    _scrollDirection = Axis.horizontal;
    _autoplayDisableOnInteraction = false;
    super.initState();
  }

// maintain the index

  Widget buildSwiper(BuildContext context) {
    return new Swiper(
      onTap: (int index) {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Sponsors"),
            ),
            body: Container(),
          );
        }));
      },
      fade: _fade,
      index: _currentIndex,
      onIndexChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      curve: _curve,
      scale: _scale,
      itemWidth: MediaQuery.of(context).size.width*0.75,
      controller: _controller,
      layout: _layout,
      outer: _outer,
      itemHeight: MediaQuery.of(context).size.height*0.5,
      viewportFraction: _viewportFraction,
      autoplayDelay: _autoplayDely,
      loop: _loop,
      autoplay: _autoplay,
      itemBuilder: _buildItem,
      itemCount: _itemCount,
      scrollDirection: _scrollDirection,
      indicatorLayout: PageIndicatorLayout.SLIDE,
      autoplayDisableOnInteraction: _autoplayDisableOnInteraction,
      pagination: new SwiperPagination(
        alignment: Alignment.bottomCenter,
          builder: const DotSwiperPaginationBuilder(
              size: 5.0, activeSize: 10.0, space: 10.0),
      ),
    );
  }

  SwiperController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Sponsors',
              style: TextStyle(color: ColorGlobal.textColor),
            ),
          ),
          body: Container(
            color: Color(0xFF544F50),
            child: Center(
              child: buildSwiper(context),
            ),
          ),
        ),
      ),
    );
  }
}