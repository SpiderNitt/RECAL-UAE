import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';
import '../Constant/ColorGlobal.dart';
import '../Events/EventPictureDisplay.dart';
class EventPhotos extends StatefulWidget {
  List<String> eventPictures;
  EventPhotos(this.eventPictures);
  @override
  _EventPhotosState createState() => _EventPhotosState();
}
class _EventPhotosState extends State<EventPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Event Photos",
            style: TextStyle(color: ColorGlobal.textColor),),
          backgroundColor: ColorGlobal.whiteColor,
          iconTheme: IconThemeData(color: ColorGlobal.textColor),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 8),
          child: GridView.count(crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: EdgeInsets.all(5),
            children: gridTiles(),
          ),
        )
    );
  }
  List<Widget> gridTiles(){
    List<Container> containers=new List<Container>.generate(widget.eventPictures.length, (index){
      return Container(
        child:InkWell(
          child: ClipRRect(
            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image:widget.eventPictures[index] ,fit: BoxFit.cover,),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
            onTap: () =>
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventPictureDisplay(widget.eventPictures[index])))
            }
        ),
      );
    });
    return containers;
  }
}
