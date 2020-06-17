import 'package:flutter/material.dart';
import './VolunteerCard.dart';

class UpcomingEvents extends StatefulWidget {
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> with TickerProviderStateMixin  {
  GlobalKey<AnimatedListState> animatedListKey=GlobalKey<AnimatedListState>();
  AnimationController emptyController;
  List events=["1","2","3","4","5","6"];
  List comp=[false,false,false,false,false,false];
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
            return SizeTransition(child: VolunteerCard(comp[index],events[index],false),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
