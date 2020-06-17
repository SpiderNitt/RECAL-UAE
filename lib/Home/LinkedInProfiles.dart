import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
          backgroundColor: Color(0xff544f50),
          appBar: AppBar(
            title: Text('LinkedIn Profiles'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                Navigator.pop(context);
              },
            ),
          ),
          body: LinkedInList(),
        ),
    );
  }
}

_launch() async {
  const url = 'https://www.linkedin.com/school/nittrichy/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class LinkedInList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: const Color(0xffdad8d9),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/linkedinIcon.png'),
                ),
                title: Text(
                  'Recal UAE Chapter',
                  style: TextStyle(
                      color: Color(0xff3aaffa),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'https://www.linkedin.com/school/nittrichy/',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                onTap: _launch, //           <-- subtitle
              )));
    },
  );
}
