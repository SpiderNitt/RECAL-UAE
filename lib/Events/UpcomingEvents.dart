import 'package:flutter/material.dart';
import 'package:iosrecal/models/EventInfo.dart';
import './VolunteerCard.dart';
class UpcomingEvents extends StatefulWidget {
  List<EventInfo> eventlist;
  UpcomingEvents(this.eventlist);
  @override
  _UpcomingEventsState createState() => _UpcomingEventsState(eventlist);
}

class _UpcomingEventsState extends State<UpcomingEvents> with TickerProviderStateMixin {
  List<EventInfo> eventList;
  _UpcomingEventsState(this.eventList);
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  AnimationController emptyController;
  List events = ["1", "2", "3", "4", "5", "6"];
  List comp = [false, false, false, false, false, false];
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    emptyController = AnimationController(
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
    return eventList.isEmpty?EmptyList():Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation){
            // return SizeTransition(child: VolunteerCard(comp[index],events[index],false),
            return SizeTransition(child: VolunteerCard(eventList[index],false,0),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
