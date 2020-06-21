import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfileScreen.dart';
import '../Constant/ShowDetailText.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/TextField.dart';
import 'package:badges/badges.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;
  final picker = ImagePicker();
  List <int> color = [0,0,0,0,0,0,0];

  TextEditingController name = new TextEditingController(text: "Madhav Aggarwal");
  TextEditingController email = new TextEditingController(text: "nitt.edu");
  TextEditingController branch = new TextEditingController(text: "CSE");
  TextEditingController year = new TextEditingController(text: "2022");
  TextEditingController phone = new TextEditingController(text: "+971-");
  TextEditingController organization = new TextEditingController(text: "");
  TextEditingController position = new TextEditingController(text: "");



  _getProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String picture = prefs.getString("profile_pic") ?? null;
  }
//  Future <Null> getImageCamera() async {
//    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
//    LostData response = await picker.getLostData();
//    print("lost: ${response.file.path}");
//    print(pickedFile.path);
//    setState(() {
//      _image = File(pickedFile.path);
//    });
//    Navigator.of(context).maybePop();
//
//  }
  Future getImageCamera() async {
    Map<Permission, PermissionStatus> permissions = await [Permission.camera].request();
    if(permissions[Permission.camera] != PermissionStatus.granted){
      openAppSettings();
      return;
    }
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    print(pickedFile.path);
    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.of(context).maybePop();
  }
  Future <Null> getImageGallery() async {
    Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
    if(permissions[Permission.storage] != PermissionStatus.granted){
      openAppSettings();
      return;
    }
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    print(pickedFile.path);
    setState(() {
      _image = File(pickedFile.path);
    });
    Navigator.of(context).maybePop();
  }


  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            height: 130,
            child: new Column(
              children: <Widget>[
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: ()  =>  getImageCamera(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorGlobal.textColor,
                        border: Border.all(color: ColorGlobal.textColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      alignment: Alignment.center,
                      child: Text("Open Camera",
                        style: TextStyle(
                            color: ColorGlobal.whiteColor, fontWeight: FontWeight.bold),
                      ),
                      height: 30.0,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () => getImageGallery(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorGlobal.textColor,
                        border: Border.all(color: ColorGlobal.textColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      alignment: Alignment.center,
                      child: Text("Choose from Gallery",
                        style: TextStyle(
                            color: ColorGlobal.whiteColor, fontWeight: FontWeight.bold),
                      ),
                      height: 30.0,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          );
        }
    );
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Save Changes?'),
        content: new Text('Do you want to save the changes?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true), //save changes here
            child: FlatButton(
              color: Colors.green,
              child: Text("NO"),
            ),
          ),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: FlatButton(
              color: Colors.red,
              child: Text("YES"),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.addListener(_nameListener);
    email.addListener(_nameListener);
    branch.addListener(_nameListener);
    year.addListener(_nameListener);
    phone.addListener(_nameListener);
    organization.addListener(_nameListener);
    position.addListener(_nameListener);
  }

  _nameListener () {
//    print("${name.text + email.text + branch.text + year.text + phone.text + organization.text + position.text}");
    List<int> list = color;
    var array = [name.text , email.text , branch.text , year.text , phone.text , organization.text , position.text];
    for(var i=0;i<7;i++) {
      if(array[i]=="")
        list[i]=0;
      else
        list[i]=1;
    }

      setState(() {
        color: list;
      });
  }
void dispose() {
  super.dispose();
  name.dispose();
  email.dispose();
  branch.dispose();
  year.dispose();
  phone.dispose();
  organization.dispose();
  position.dispose();
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorGlobal.whiteColor,
            leading: IconButton(
              icon: Icon(Icons.close, color: ColorGlobal.textColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.check),
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pop();
              },
                color: ColorGlobal.blueColor,
                padding: EdgeInsets.only(right: 20),
              )
            ],
            title: Text('Edit Profile',style: TextStyle(color: ColorGlobal.textColor),),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Center(
                    child: Column(
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {_settingModalBottomSheet(context);},
                          child: _image==null ? new Container(
                            height: 140,
                            width: 140,
                            decoration: new BoxDecoration(
                              color: ColorGlobal.colorPrimaryDark,
                              image: new DecorationImage(
                                image: new AssetImage('assets/images/spiderlogo.png'),
                                fit: BoxFit.contain,
                              ),
                              border: Border.all(color: ColorGlobal.colorPrimaryDark, width: 2),
                              borderRadius:
                              new BorderRadius.all(const Radius.circular(70.0)),
                            ),
                            )  : new Container(
                              width: 140.0,
                              height: 140.0,
                              decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: ColorGlobal.textColor),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:  FileImage(_image)
                                  )
                              )
                          ),
                        ),
                        SizedBox(height: 10,),
                        Center(
                          child: GestureDetector (
                            onTap: () {_settingModalBottomSheet(context);},
                            child: Text("Change Profile Photo", style: TextStyle(color: ColorGlobal.blueColor,fontSize: 16.0,fontWeight: FontWeight.w400),),
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: ShowDetailTextWidget(
                            hintText: 'Name',
                            controller: name,
                            color: color[0]==0 ? Colors.red : ColorGlobal.blueColor,
                          )
                        ),
                        Container(
                            child: ShowDetailTextWidget(
                              hintText: 'Email',
                              controller: email,
                              color: color[1]==0 ? Colors.red : ColorGlobal.blueColor,
                            )
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  child: ShowDetailTextWidget(
                                    hintText: 'Branch',
                                    controller: branch,
                                    color: color[2]==0 ? Colors.red : ColorGlobal.blueColor,
                                  )
                              ),
                            ),

                            SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                  child: ShowDetailTextWidget(
                                    hintText: 'Year of passing',
                                    controller: year,
                                    type: 'number',
                                    color: color[3]==0 ? Colors.red : ColorGlobal.blueColor,
                                  )
                              ),
                            ),
                          ],
                        ),
                        Container(
                            child: ShowDetailTextWidget(
                              hintText: 'Phone Number',
                              controller: phone,
                              type: 'phone',
                              color: color[4]==0 ? Colors.red : ColorGlobal.blueColor,
                            )
                        ),
                        Container(
                            child: ShowDetailTextWidget(
                              hintText: 'Organization',
                              controller: organization,
                              color: color[5]==0 ? Colors.red : ColorGlobal.blueColor,
                            )
                        ),
                        Container(
                            child: ShowDetailTextWidget(
                              hintText: 'Position',
                              controller: position,
                              color: color[6]==0 ? Colors.red : ColorGlobal.blueColor,
                            )
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),

            ),
          )
        ),
      ),
    );
  }
}
