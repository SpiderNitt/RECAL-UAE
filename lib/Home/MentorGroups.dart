import 'package:flutter/material.dart';
import './MentorList.dart';

void main() => runApp(MentorGroups());

class MentorGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MentorGroupsPage(),
        routes: {
          '/mentorList': (context) => MentorList(),
        }
    );
  }
}
class MentorGroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Do something
                }
            ),
            expandedHeight: 250.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: const Color(0xFF3AAFFA),
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Mentor Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                background: Hero(
                  tag: 'imageHero',
                  child: Image.asset(
                    "assets/images/mentor_groups.jpg",
                    fit: BoxFit.cover,
                  ),
                )
            ),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(_buildList(6, context))
          ),
        ],
      ),
    );
  }

  List _buildList(int count, BuildContext context) {
    List<Widget> listItems = List();
    List<String> groups = List();
    groups.add("IT and Related Services");
    groups.add("Energy");
    groups.add("Construction");
    groups.add("Banking/Finance/Investment");
    groups.add("Trading/MFG/Recycling");
    groups.add("Education/Others");

    for (int i = 0; i < count; i++) {
      String t = 'textHero' + i.toString();
      listItems.add(new Padding(padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Hero(
                    tag : t,
                    child: new Text(
                        groups[i],
                        style: new TextStyle(fontSize: 18.0)
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 30.0,
                    child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                          color: Color(0x88000000),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/mentorList');
                          // Do something
                        }
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              const Divider(
                color: const Color(0x22000000),
                height: 1,
                thickness: 1,
              ),
            ],
          )
      ),
      );
    }

    return listItems;
  }
}