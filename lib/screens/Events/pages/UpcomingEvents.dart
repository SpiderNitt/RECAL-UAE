import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/models/EventInfo.dart';
import '../widgets/EventCard.dart';
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
      child: Text("No upcoming events",style: GoogleFonts.josefinSans(fontSize: UIUtility().getProportionalWidth(width: 22,choice: 0),color: ColorGlobal.textColor)),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    UIUtility().updateScreenDimesion(
        width: screenSize.width, height: screenSize.height);

    return eventList.isEmpty?EmptyList():Container(
      child: AnimatedList(
          key: animatedListKey,
          initialItemCount: eventList.length,
          itemBuilder: (BuildContext context, int index,animation){
            return SizeTransition(child: VolunteerCard(eventList[index],false,0,2),
              sizeFactor: animation,);
          }
      ),

    );
  }
}
