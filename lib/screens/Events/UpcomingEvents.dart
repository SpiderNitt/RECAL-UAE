import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/Constant/ColorGlobal.dart';
import 'package:iosrecal/models/EventInfo.dart';
import 'VolunteerCard.dart';
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
      child: Text("No events yet !!",style: GoogleFonts.kalam(fontSize: 22,color: ColorGlobal.textColor)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return eventList.isEmpty?EmptyList():Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation){
            return SizeTransition(child: VolunteerCard(eventList[index],false,0),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
