import 'package:flutter/material.dart';
import '../Constant/ColorGlobal.dart';
import 'CompletedEvents.dart';
import 'UpcomingEvents.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  double position=1;
  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorGlobal.whiteColor,
          title: Text(
            'Events',
            style: TextStyle(color: ColorGlobal.textColor),
          ),
        ),
        body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Material(
              color: ColorGlobal.blueColor,
              child: TabBar(
                indicatorColor: ColorGlobal.textColor,
                indicatorWeight: 3,
                unselectedLabelColor: ColorGlobal.whiteColor.withOpacity(0.5),
                onTap: (index){
                  setState(() {
                    position = 0;
                  });
                },
                tabs:[
                  Tab(icon:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 2,
                      ),
                      Icon(Icons.timer,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Upcoming",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  ),
                  Tab(icon:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 2,
                      ),
                      Icon(Icons.check_circle),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Completed",
                          style: TextStyle(fontSize: 14,),
                        ),
                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  UpcomingEvents(),
                  CompletedEvents(),
                ],
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}
