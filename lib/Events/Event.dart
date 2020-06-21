import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Constant/ColorGlobal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
class Event extends StatefulWidget {
  bool isCompleted=false;
  String num;
  Event(bool isComp,String tag){
    isCompleted=isComp;
    num=tag;
  }
  @override
  _EventState createState() => _EventState(isCompleted,num);
}

class _EventState extends State<Event> {
  bool checkComplete;
  String num;
  _EventState(bool isComp,String tag){
    checkComplete=isComp;
    num=tag;
  }
  final List<int> numbers = [1, 2, 3, 4, 5, 5, 2, 3, 5];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: Text("RECAL UAE Meet",style: TextStyle(color: ColorGlobal.textColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorGlobal.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: ColorGlobal.whiteColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorGlobal.blueColor.withOpacity(0.5),width: 2)
                ),
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: "https://picsum.photos/300",fit: BoxFit.fitWidth,),
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "September 20, 2020",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        Text(
                          "5pm - 10pm",
                          style: TextStyle(color: Colors.blueGrey),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.place,
                                size: 36,
                                color: ColorGlobal.color2,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: Text(
                                      "Emirate",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text(
                              " Detailed description of the event.",
                              style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                            )),
                        checkComplete?Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: numbers.length, itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Card(
                                //color: Colors.blue,
                                child: Container(
                                  child: Image.network("https://picsum.photos/300",fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext ctx, Widget child, ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }else {
                                        return Center(
                                          child: SpinKitDoubleBounce(
                                            color: Colors.lightBlueAccent,
                                          ),
                                        );
                                      }
                                    },       ),
                                ),
                              ),
                            );
                          }),
                        ):Container(margin: EdgeInsets.only(top:4),child: InkWell(child: Text("Register Here",style: TextStyle(color: Colors.blue)),onTap: ()=>launch("https://picsum.photos/300"),)),
                        checkComplete?SizedBox(height: 0,width: 0,):SizedBox(height: 20,),
                        !checkComplete?Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: OutlineButton(
                            splashColor: Colors.green,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.check_circle,color: Colors.green,),
                                SizedBox(width: 10,),
                                Text(
                                  "Volunteer",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            onPressed: () {

                            },
                            color: Colors.white,
                            borderSide: BorderSide(
                                color: Colors.green,
                                style: BorderStyle.solid,
                                width: 0.8),
                          ),
                        ):SizedBox(height: 0,width: 0,),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
