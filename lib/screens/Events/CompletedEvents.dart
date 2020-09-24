import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/Constant/utils.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'VolunteerCard.dart';
class CompletedEvents extends StatefulWidget {
  List<EventInfo> list;
  int status;
  CompletedEvents(this.list,this.status);
  @override
  _CompletedEventsState createState() => _CompletedEventsState(list);
}

class _CompletedEventsState extends State<CompletedEvents> with TickerProviderStateMixin  {
  List<EventInfo> eventList;
  _CompletedEventsState(this.eventList);
  GlobalKey<AnimatedListState> animatedListKey=GlobalKey<AnimatedListState>();
  AnimationController emptyController;
  bool isEmpty=false;

  @override
  void initState() {
    super.initState();
    emptyController=AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    emptyController.forward();
  }
  Widget EmptyList(BuildContext context){
    return Center(
      child: Text("No events to show!!",style: GoogleFonts.josefinSans(fontSize: UIUtills().getProportionalHeight(height: 22),color: ColorGlobal.textColor),),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtills().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return eventList.isEmpty?EmptyList(context):Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation){
            return SizeTransition(child: VolunteerCard(eventList[index],true,widget.status),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
