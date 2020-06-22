import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ResponseBody.dart';
import '../models/User.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ProfileScreen.dart';
import '../Constant/ShowDetailText.dart';
import '../Constant/ColorGlobal.dart';
import '../Constant/TextField.dart';
import 'package:badges/badges.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';


class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _image;
  final picker = ImagePicker();
  List<int> color = new List<int>.generate(9, (i) => 0);
  User user;
  int flag = 0;
  int dialog = 0;
  String previous = "", after = "";

  TextEditingController name;
  TextEditingController email;
  TextEditingController branch;
  TextEditingController year;
  TextEditingController phone;
  TextEditingController organization;
  TextEditingController position;
  TextEditingController emirate;
  TextEditingController gender;
  ProgressDialog pr;

  Future getImageCamera() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.camera].request();
    if (permissions[Permission.camera] != PermissionStatus.granted) {
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

  Future<Null> getImageGallery() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.storage].request();
    if (permissions[Permission.storage] != PermissionStatus.granted) {
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 130,
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () => getImageCamera(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorGlobal.textColor,
                        border: Border.all(color: ColorGlobal.textColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Open Camera",
                        style: TextStyle(
                            color: ColorGlobal.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      height: 30.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                      child: Text(
                        "Choose from Gallery",
                        style: TextStyle(
                            color: ColorGlobal.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      height: 30.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Save Changes?'),
            content: new Text('Do you want to save the changes?'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () =>
                    Navigator.of(context).pop(true), //save changes here
                child: FlatButton(
                  color: Colors.green,
                  child: Text("NO"),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  if (flag == 1) {
                    after = name.text +
                        email.text +
                        DropDown.branch +
                        DropDown.year.toString() +
                        phone.text +
                        organization.text +
                        position.text +
                        DropDown.emirate +
                        DropDown.gender;
                    print(previous);
                    print(after);
                    if (previous == after)
                      Navigator.of(context).pop();
                    else {

                      _postUserDetails();
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
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

  _userDialog(String show, String again, int flag) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
      showLogs: true,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
      message: "Saving details",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressWidgetAlignment: Alignment.center,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );
    pr.show();
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      pr.update(message: show,progressWidget: Text(""));
    });
    Future.delayed(Duration(milliseconds: 2500)).then((value) {
      pr.hide();
    });
  }


    _nameListener() {
//    print("${name.text + email.text + branch.text + year.text + phone.text + organization.text + position.text}");
      List<int> list = color;
      var array = [
        name.text,
        email.text,
        branch.text,
        year.text,
        phone.text,
        organization.text,
        position.text,
        emirate.text,
        gender.text,
      ];
      for (var i = 0; i < 9; i++) {
        if (array[i] == "")
          list[i] = 0;
        else
          list[i] = 1;
      }

      setState(() {
        color:
        list;
      });
    }

    Future<dynamic> _getUserDetails() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_id =
      prefs.getString("user_id") == null ? -1 : prefs.getString("user_id");
      String cookie =
      prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

      print("USERID Profile: $user_id");
      print("cookie profile: $cookie");

      var url = "https://delta.nitt.edu/recal-uae/api/users/profile/";
      var uri = Uri.parse(url);
      uri = uri.replace(query: "user_id=$user_id");

      await http.get(uri, headers: {'Cookie': cookie}).then((_response) {
        print(_response.statusCode);
        print(_response.body);
        if (_response.statusCode == 200) {
          ResponseBody responseBody =
          ResponseBody.fromJson(json.decode(_response.body));
          print(json.encode(responseBody.data));
          if (responseBody.status_code == 200) {
            user =
                User.fromProfile(json.decode(json.encode(responseBody.data)));
            print(user.organization);

            setState(() {
              flag = 1;
              name = new TextEditingController(text: user.name);
              email = new TextEditingController(text: user.email);
              branch = new TextEditingController(text: user.branch);
              year =
              new TextEditingController(text: "${user.year_of_graduation}");
              phone = new TextEditingController(text: user.mobile_no);
              organization = new TextEditingController(text: user.organization);
              gender = new TextEditingController(text: user.gender);
              emirate = new TextEditingController(text: user.emirate);
              position = new TextEditingController(text: user.position);

              previous = name.text +
                  email.text +
                  branch.text +
                  year.text.toString() +
                  phone.text +
                  organization.text +
                  position.text +
                  emirate.text +
                  gender.text;
            });
            name.addListener(_nameListener);
            email.addListener(_nameListener);
            branch.addListener(_nameListener);
            year.addListener(_nameListener);
            phone.addListener(_nameListener);
            organization.addListener(_nameListener);
            position.addListener(_nameListener);
            gender.addListener(_nameListener);
            emirate.addListener(_nameListener);

            DropDown.gender = gender.text;
            DropDown.emirate = emirate.text;
            DropDown.year = int.parse(year.text);
            DropDown.branch = branch.text;
          } else {
            setState(() {
              flag = 2;
            });
            print("${responseBody.data}");
          }
        } else {
          setState(() {
            flag = 2;
          });
          print("Server error");
        }
      }).catchError((error) {
        flag = 2;
        print(error);
      });
    }

    _postUserDetails() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_id = prefs.getString("user_id") == null
          ? "+9,q"
          : prefs.getString("user_id");
      String cookie =
      prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");

      print("USERID Profile: $user_id");
      print("cookie profile: $cookie");
      print(
          "branch emirate year gender ${DropDown.branch} ${DropDown
              .emirate} ${DropDown.year.toString()} ${DropDown.gender}");
      var url = "https://delta.nitt.edu/recal-uae/api/users/update/";
      var body = {
        "id": user_id.toString(),
        "email": email.text,
        "name": name.text,
        "year": DropDown.year.toString(),
        "mobile_no": phone.text,
        "organization": organization.text,
        "position": position.text,
        "gender": DropDown.gender,
        "branch": DropDown.branch,
        "emirate": DropDown.emirate,
        "is_admin": "1",
        "linkedIn": " ",
      };
      await http.post(
        url,
        body: body,
        headers: {
          "Cookie": cookie,
        },
      ).then((_response) {
        print(_response);
        ResponseBody responseBody = new ResponseBody();

        if (_response.statusCode == 200) {
          responseBody = ResponseBody.fromJson(json.decode(_response.body));

          print(json.encode(responseBody.data));
          if (responseBody.status_code == 200) {
            FocusManager.instance.primaryFocus.unfocus();
            _userDialog("Details Updated", "Okay", 1);
            Future.delayed(Duration(milliseconds: 2500), () {
              Navigator.pop(context);
            });
          } else if (responseBody.status_code == 500) {
            print(responseBody.data);
            var response = json.decode(json.encode(responseBody.data));
            String exception = response["exception_message"];
            setState(() {
              dialog = 1;
            });
            _userDialog("Please provide unique details", "Try again", 0);
          } else {
            print("${responseBody.status_code}");
            setState(() {
              dialog = 1;
            });
            _userDialog("Error saving details", "Try again", 0);
          }
        } else {
          setState(() {
            dialog = 1;
          });
          _userDialog("Server error, could not save details", "Try again", 0);
          print("server error");
        }
      });
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _getUserDetails();
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
      gender.dispose();
      emirate.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      final height = MediaQuery
          .of(context)
          .size
          .height;

      return WillPopScope(
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: ColorGlobal.whiteColor,
                leading: IconButton(
                  icon: Icon(Icons.close, color: ColorGlobal.textColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 30,
                    onPressed: () {
                      if (flag == 1) {
                        after = name.text +
                            email.text +
                            DropDown.branch +
                            DropDown.year.toString() +
                            phone.text +
                            organization.text +
                            position.text +
                            DropDown.emirate +
                            DropDown.gender;
                        print(previous);
                        print(after);
                        if (previous == after)
                          Navigator.of(context).pop();
                        else {
                          _postUserDetails();
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    color: ColorGlobal.blueColor,
                    padding: EdgeInsets.only(right: 20),
                  )
                ],
                title: Text(
                  'Edit Profile',
                  style: TextStyle(color: ColorGlobal.textColor),
                ),
              ),
              body: flag == 0
                  ? Center(child: CircularProgressIndicator())
                  : (flag == 2
                  ? Center(child: Text("Error please try again"))
                  : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                _settingModalBottomSheet(context);
                              },
                              child: _image == null
                                  ? new Container(
                                height: 120,
                                width: 120,
                                decoration: new BoxDecoration(
                                  color: ColorGlobal
                                      .colorPrimaryDark,
                                  image: new DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/spiderlogo.png'),
                                    fit: BoxFit.contain,
                                  ),
                                  border: Border.all(
                                      color: ColorGlobal
                                          .colorPrimaryDark,
                                      width: 2),
                                  borderRadius:
                                  new BorderRadius.all(
                                      const Radius.circular(
                                          60.0)),
                                ),
                              )
                                  : new Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ColorGlobal
                                              .textColor),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                          FileImage(_image)))),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _settingModalBottomSheet(context);
                                },
                                child: Text(
                                  "Change Profile Photo",
                                  style: TextStyle(
                                      color: ColorGlobal.blueColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: ShowDetailTextWidget(
                                  hintText: 'Name',
                                  controller: name,
                                  color: color[0] == 0
                                      ? Colors.red
                                      : ColorGlobal.blueColor,
                                )),
                            Container(
                                child: ShowDetailTextWidget(
                                  hintText: 'Organization',
                                  controller: organization,
                                  color: color[5] == 0
                                      ? Colors.red
                                      : ColorGlobal.blueColor,
                                )),
                            Container(
                                child: ShowDetailTextWidget(
                                  hintText: 'Position',
                                  controller: position,
                                  color: color[6] == 0
                                      ? Colors.red
                                      : ColorGlobal.blueColor,
                                )),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: DropDown(
                                      select: 0,
                                      hint: branch.text,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Container(
                                    child: DropDown(
                                      select: 1,
                                      hint: year.text,
                                    ),
                                  ),
                                  flex: 3,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Profile Information:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                child: ShowDetailTextWidget(
                                  hintText: 'Email',
                                  controller: email,
                                  color: color[1] == 0
                                      ? Colors.red
                                      : ColorGlobal.blueColor,
                                )),
                            Container(
                              child: ShowDetailTextWidget(
                                hintText: 'Phone Number',
                                controller: phone,
                                type: 'phone',
                                color: color[4] == 0
                                    ? Colors.red
                                    : ColorGlobal.blueColor,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: DropDown(
                                      select: 2,
                                      hint: emirate.text,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Container(
                                    child: DropDown(
                                      select: 3,
                                      hint: gender.text,
                                    ),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
        ),
      );
    }
  }

class Gender {
  String name;
  int index;
  Gender({this.name, this.index});
}

class DropDown extends StatefulWidget {
  final int select;
  final String hint;
  static String branch;
  static int year;
  static String emirate;
  static String gender;
  DropDown({Key key, this.select, this.hint}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _branch;
  int _year;
  String _emirate;
  String _gender;

  List<Gender> gList = [
    Gender(
      index: 1,
      name: "Male",
    ),
    Gender(
      index: 2,
      name: "Female",
    ),
    Gender(
      index: 3,
      name: "Custom",
    ),
    Gender(
      index: 4,
      name: "Prefer Not to Say",
    ),
  ];
  getId(String value) {
    for (int i = 0; i < 4; i++) {
      if (gList[i].name == value) return gList[i].index;
    }
  }

  List<int> all = new List<int>();

  List<int> getYears() {
    all = new List<int>();
    for (var i = 2019; i >= 1964; i--) all.add(i);
    return all;
  }

  List<String> getBranches() {
    return [
      "CSE",
      "ECE",
      "EEE",
      "MECH",
      "PROD",
      "ICE",
      "CHEM",
      "CIVIL",
      "META",
      "ARCHI",
      "PhD/MSc/MS",
      "M.DOMS",
      "MCA",
      "MTECH"
    ];
  }

  List<String> getEmirates() {
    return [
      "Umm Al Quwain",
      "Sharjah",
      "Ras Al Khaimah",
      "Fujairah",
      "Dubai",
      "Ajman",
      "Abu Dhabi"
    ];
  }

  @override
  Widget build(BuildContext context) {
//    print('${widget.select}\n');
//    print(_branch);
//    print(all);
    if (widget.select == 0) {
      return DropdownButtonHideUnderline(
        child: new InputDecorator(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: "Branch",
            labelStyle: TextStyle(color: ColorGlobal.blueColor),
          ),
          child: DropdownButton<String>(
            hint: AutoSizeText(
              widget.hint,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            icon: Icon(Icons.arrow_drop_down),
            value: _branch,
            isExpanded: true,
            iconSize: 18,
            elevation: 10,
            style: TextStyle(color: Colors.black, fontSize: 15.0),
            onChanged: (String newValue) {
              setState(() {
                _branch = newValue;
                DropDown.branch = newValue;
              });
            },
            items: getBranches().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    } else if (widget.select == 1) {
      return DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: "Year of passing",
            labelStyle: TextStyle(color: ColorGlobal.blueColor),
          ),
          child: DropdownButton<int>(
            hint: AutoSizeText(widget.hint,
                style: TextStyle(color: Colors.black, fontSize: 15.0)),
            value: _year,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 18,
            isExpanded: true,
            elevation: 10,
            style: TextStyle(color: Colors.black, fontSize: 15.0),
            onChanged: (int newValue) {
              setState(() {
                _year = newValue;
                DropDown.year = newValue;
              });
            },
            items: getYears().map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          ),
        ),
      );
    } else if (widget.select == 2) {
      return DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: "Emirate",
            labelStyle: TextStyle(color: ColorGlobal.blueColor),
          ),
          child: DropdownButton<String>(
            hint: Text(
              widget.hint,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            value: _emirate,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 18,
            elevation: 10,
            isExpanded: true,
            style: TextStyle(color: Colors.black, fontSize: 15.0),
            onChanged: (String newValue) {
              setState(() {
                _emirate = newValue;
                DropDown.emirate = newValue;
              });
            },
            items: getEmirates().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: "Gender",
            labelStyle: TextStyle(color: ColorGlobal.blueColor),
          ),
          child: DropdownButton<String>(
            hint: Text(
              widget.hint,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            value: _gender,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 18,
            elevation: 10,
            isExpanded: true,
            style: TextStyle(color: Colors.black, fontSize: 15.0),
            onChanged: (String newValue) {
              setState(() {
                _gender = newValue;
                DropDown.gender = newValue;
              });
            },
            items: gList.map<DropdownMenuItem<String>>((Gender value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}
