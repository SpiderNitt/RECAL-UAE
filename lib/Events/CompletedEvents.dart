import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iosrecal/models/EventInfo.dart';
import './VolunteerCard.dart';
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
  List events=["1","2","3","4","5","6"];
  List comp=[true,true,true,true,true,true];
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
  Widget EmptyList(){
    return Center(
      child: FadeTransition(child: Text("No events to show!!"),
        opacity: emptyController,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return eventList.isEmpty?EmptyList():Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation){
            //return SizeTransition(child: VolunteerCard(comp[index],events[index],Random().nextInt(2)==1 ? true : false),
            return SizeTransition(child: VolunteerCard(eventList[index],true,widget.status),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
