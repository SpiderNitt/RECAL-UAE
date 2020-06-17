import 'dart:math';

import 'package:flutter/material.dart';
import './VolunteerCard.dart';
class CompletedEvents extends StatefulWidget {
  @override
  _ColpletedEventsState createState() => _ColpletedEventsState();
}

class _ColpletedEventsState extends State<CompletedEvents> with TickerProviderStateMixin  {
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
      child: FadeTransition(child: Text("No events yet!!"),
        opacity: emptyController,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return isEmpty?EmptyList():Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: events.length,
          itemBuilder: (BuildContext context, int index,animation){
            return SizeTransition(child: VolunteerCard(comp[index],events[index],Random().nextInt(2)==1 ? true : false),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
