import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:iosrecal/routes.dart';
import 'package:iosrecal/constants/UIUtility.dart';
import 'package:iosrecal/constants/Api.dart';
import 'package:iosrecal/bloc/KeyboardBloc.dart';
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:iosrecal/models/User.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import '../ProfileScreen.dart';
import 'package:iosrecal/widgets/ShowDetailText.dart';
import 'package:iosrecal/constants/ColorGlobal.dart';
import 'package:badges/badges.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_utils/keyboard_listener.dart';


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
  int flag = 0, getBranch=0;
  int dialog = 0;
  String previous = "", after = "";
  int change_dp=0;
  int clickSave=0;
  var _formkey = GlobalKey<FormState>();
  bool args;
  KeyboardBloc _bloc = KeyboardBloc();
  bool internetConnection=true;
  UIUtility uiUtills = new UIUtility();
  dynamic allBranch;

  TextEditingController name;
  TextEditingController email;
  TextEditingController branch;
  TextEditingController year;
  TextEditingController phone;
  TextEditingController organization;
  TextEditingController position;
  TextEditingController emirate;
  TextEditingController gender;
  String picture;
  ProgressDialog progressDialog;
  int getPic=0;

  Future getImageCamera() async {
    Map<Permission, PermissionStatus> permissions =
    await [Permission.camera].request();
    if (permissions[Permission.camera] != PermissionStatus.granted) {
      openAppSettings();
      return;
    }
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    print(pickedFile.path);
    if (!mounted) return; setState(() {
      _image = File(pickedFile.path);
      change_dp=1;
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
    if (!mounted) return; setState(() {
      _image = File(pickedFile.path);
      change_dp=1;
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
  navigateAndReload() {
    Navigator.pushNamed(context, LOGIN_SCREEN, arguments: true)
        .then((value) {
      Navigator.pop(context);
    });
  }
  Future<bool> onTimeOut() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: new Text('Session Timeout'),
        content: new Text('Login to continue'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              navigateAndReload();
            },
            child: Text("OK"),
          ),
        ],
      ),
    ) ??
        false;
  }



  _userDialog(String show, String again, int flag) {
    if(progressDialog==null) {
      progressDialog = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        textDirection: TextDirection.rtl,
        showLogs: true,
        isDismissible: false,
      );

      progressDialog.style(
        message: "Saving details",
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressWidget: Image.asset(
          "assets/images/ring.gif", height: 50, width: 50,),
        progressWidgetAlignment: Alignment.center,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: getWidth(18, 1),
            fontWeight: FontWeight.w600),
        progressTextStyle: TextStyle(
            color: Colors.black,             fontSize: getWidth(18, 1)
            , fontWeight: FontWeight.w600),
      );
      progressDialog.show();
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        Widget prog = flag == 1 ? Icon(
          Icons.check_circle, size: 50, color: Colors.green,) : Icon(
          Icons.close, size: 50, color: Colors.red,);
        progressDialog.update(
            message: show.replaceAll("!", ""), progressWidget: prog);
      });
      Future.delayed(Duration(milliseconds: 2000)).then((value) {
        progressDialog.hide();
        if (!mounted) return; setState(() {
          progressDialog = null;
          clickSave=0;
        });
      });
    }
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

    if (!mounted) return; setState(() {
      color:
      list;
    });
  }
  Future<bool> _uploadProfilePic (String user_id, String cookie) async {

    print("image: " + _image.path);
    final length = await _image.length();
    var request = http.MultipartRequest('POST', Uri.parse(Api.addFile))
      ..headers.addAll({"Cookie": cookie})
      ..fields["file_type"] = "profile_picture"
      ..fields["user_id"] = user_id
      ..files.add(await http.MultipartFile.fromPath("user_file",_image.path));


    await http.Response.fromStream(await request.send()).then((_response) {
      print("INSIDE PROFILE PIC");
      ResponseBody responseBody = new ResponseBody();
      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));

        print(responseBody);

        if (responseBody.status_code == 200) {
          FocusManager.instance.primaryFocus.unfocus();
          print("profile pic updated");
          _userDialog("Details Updated", "Okay", 1);
          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.pop(context);
          });
          return true;
        }
        else if (responseBody.status_code == 401) {
          onTimeOut();
        }
        else if (responseBody.status_code == 500) {
          print(responseBody);
          _userDialog("Error saving details", "Okay", 0);
          return false;
        } else {
          print("${responseBody.status_code}");
          _userDialog("Error saving details", "Okay", 0);
          return false;
        }
      } else {
        print("server error");
        _userDialog("Error saving details", "Okay", 0);
        return false;
      }
    }).catchError((error) {
      print("$error");
      _userDialog("Error saving details", "Okay", 0);
      return false;
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

    var url = Api.getUser;
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

          if (!mounted) return;
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
            picture = user.profile_pic;

            if(user.profile_pic!=null)
              setState(() {
              picture = Api.imageUrl + user.profile_pic;
              getPic=1;
            });

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
        }
        else if (responseBody.status_code == 401) {
          onTimeOut();
        }
        else {
          if (!mounted) return; setState(() {
            flag = 2;
          });
          print("${responseBody.data}");
        }
      } else {
        if (!mounted) return; setState(() {
          flag = 2;
        });
        print("Server error");
      }
    }).catchError((error) {
      flag = 2;
      print(error);
    });
  }
  _getBranches()  async {
    var url = Api.getBranch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookie = prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    await http.get(
      url,
      headers: {
        "Cookie": cookie,
      },
    ).then((_response) async {
      print(_response);
      ResponseBody responseBody = new ResponseBody();

      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        if (responseBody.status_code == 200) {
          print(responseBody.data);
          setState(() {
            getBranch=1;
          });
          setState(() {
            allBranch = responseBody.data;
          });
        } else if (responseBody.status_code == 500) {
          setState(() {
            getBranch=2;
          });
          print(responseBody.data);
        } else {
          setState(() {
            getBranch=2;
          });
          print("${responseBody.status_code}");
        }
      } else {
        setState(() {
          getBranch=2;
        });
        print("server error");
      }
    }).catchError((error) {
      setState(() {
        getBranch=2;
      });
      print("server error");
    });
//    return [
//      "CSE",
//      "ECE",
//      "EEE",
//      "MECH",
//      "PROD",
//      "ICE",
//      "CHEM",
//      "CIVIL",
//      "META",
//      "ARCHI",
//      "PhD/MSc/MS",
//      "M.DOMS",
//      "MCA",
//      "MTECH"
//    ];
  }

  _postUserDetails() async {
    int yes=0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") == null
        ? "+9,q"
        : prefs.getString("user_id");
    String cookie =
    prefs.getString("cookie") == null ? "+9,q" : prefs.getString("cookie");
    prefs.setString("email", email.text);
    prefs.setString("name", name.text);

    print("USERID Profile: $user_id");
    print("cookie profile: $cookie");
    print(
        "branch emirate year gender ${DropDown.branch} ${DropDown
            .emirate} ${DropDown.year.toString()} ${DropDown.gender}");
    var url = Api.updateUser;
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
    ).then((_response) async {
      print(_response);
      ResponseBody responseBody = new ResponseBody();

      if (_response.statusCode == 200) {
        responseBody = ResponseBody.fromJson(json.decode(_response.body));
        print(json.encode(responseBody.data));
        if (responseBody.status_code == 200) {
          FocusManager.instance.primaryFocus.unfocus();
          yes=1;

          var url = Api.getUser;

          var uri = Uri.parse(url);
          uri = uri.replace(query: "user_id=$user_id");

          await http.get(uri, headers: {'Cookie': cookie}).then((_response) async {
            print(_response.statusCode);
            print(_response.body);
            if (_response.statusCode == 200) {
              ResponseBody responseBody =
              ResponseBody.fromJson(json.decode(_response.body));
              print(json.encode(responseBody.data));
              if (responseBody.status_code == 200) {
                User recal_user = User.fromProfile(json.decode(json.encode(responseBody.data)));
                String picture1 = recal_user.profile_pic;
                if(picture1!=null) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("profile_picture",Api.imageUrl + picture1);
                }
                print("display picture get after upload: $picture1");
              }
              else if (responseBody.status_code == 401) {
                onTimeOut();
              }
              else {
                print("${responseBody.data}");
              }
            } else {
              print("Server error");
              _userDialog("Server error, could not save details", "Try again", 0);

            }
          }).catchError((error) {
            print(error);
            _userDialog("Server error, could not save details", "Try again", 0);
          });
        } else if (responseBody.status_code == 500) {
          print(responseBody.data);
          if (!mounted) return;
          setState(() {
            dialog = 1;
          });
          _userDialog("Invalid details", "Try again", 0);
        } else {
          print("${responseBody.status_code}");
          if (!mounted) return;
          setState(() {
            dialog = 1;
          });
          _userDialog("Error saving details", "Try again", 0);
        }
      } else {
        print(responseBody.data);
        if (!mounted) return; setState(() {
          dialog = 1;
        });
        _userDialog("Server error, could not save details", "Try again", 0);

        print("server error");
      }
    }).catchError((error) {
      print("$error");
      _userDialog("Server error, could not save details", "Try again", 0);
      print("server error");
    });
    if(yes==1) {
      if (change_dp == 1) {
        await _uploadProfilePic(user_id, cookie);
      }
      else {
        _userDialog("Details Updated", "Okay", 1);
        Future.delayed(Duration(milliseconds: 2000), () {
          Navigator.pop(context);
        });
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
    _getBranches();
    _bloc.start();
  }

  void dispose() {
    _bloc.dispose();
    name.dispose();
    email.dispose();
    branch.dispose();
    year.dispose();
    phone.dispose();
    organization.dispose();
    position.dispose();
    gender.dispose();
    emirate.dispose();
    super.dispose();
  }

  double getHeight(double height, int choice) {
    return uiUtills.getProportionalHeight(height: height, choice: choice);
  }

  double getWidth(double width, int choice) {
    return uiUtills.getProportionalWidth(width: width, choice: choice);
  }


  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    uiUtills.updateScreenDimesion(width: width,height: height);

    return WillPopScope(
      child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: true,
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
                    onPressed: () async {
                      if(flag==1 && getBranch==1) {
                        final FormState form = _formkey.currentState;
                        if (form.validate()) {
                          if (progressDialog == null && clickSave == 0) {
                            setState(() {
                              clickSave = 1;
                            });
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
                              if (previous == after && change_dp == 0)
                                Navigator.of(context).pop();
                              else {
                                try {
                                  final result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                    setState(() {
                                      internetConnection=true;
                                    });
                                   await _postUserDetails();
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                      msg: "Please connect to internet",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16,
                                    );
                                    setState(() {
                                      internetConnection = false;
                                      clickSave=0;
                                    });
                                  }
                                } on SocketException catch (_) {
                                  print('not connected');
                                  Fluttertoast.showToast(
                                    msg: "Please connect to internet",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16,
                                  );
                                  setState(() {
                                    internetConnection = false;
                                    clickSave=0;
                                  });
                                }
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        } else {
                          print("form not valid");
                        }
                      }
                    },
                    color: ColorGlobal.blueColor,
                    padding: EdgeInsets.only(right: getWidth(20, 1)),
                  )
                ],
                title: Text(
                  'Edit Profile',
                  style: TextStyle(color: ColorGlobal.textColor),
                ),
              ),
              body: (flag == 0 || getBranch==0)
                  ? Center(child: CircularProgressIndicator())
                  : (flag == 2 || getBranch==2)
                  ? Center(child:Text("Error fetching data \nPlease try after sometime",style:GoogleFonts.josefinSans(fontSize: 20,color: ColorGlobal.textColor))
              )
                  : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(getWidth(16, 1)),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formkey,
                    autovalidate: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          height: getHeight(10, 1),
                        ),
                            new GestureDetector(
                              onTap: () {
                                _settingModalBottomSheet(context);
                              },
                              child: getPic == 0 && change_dp==0
                                  ? CircleAvatar(
                                radius: getWidth(60, 1),
                                backgroundColor: Colors.orange,
                                child: Text(name.text.toUpperCase()[0], style: TextStyle(color: Colors.white, fontSize: getWidth(60, 1)),)
                                )
                                  : new Container(
                                  width: getWidth(120, 1),
                                  height: getWidth(120, 1),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ColorGlobal
                                              .textColor),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: _image==null && change_dp==0 ? NetworkImage(picture) : FileImage(_image)))),
                            ),
                            SizedBox(
                              height: getHeight(5, 1),
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
                                      fontSize: getWidth(16, 1),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),

                            ShowDetailTextWidget(
                              hintText: 'Name',
                              controller: name,
                              color: color[0] == 0
                                  ? Colors.red
                                  : ColorGlobal.blueColor,
                            ),
                        ShowDetailTextWidget(
                          hintText: 'Email',
                          controller: email,
                          readOnly: true,
                          color: color[4] == 0
                              ? Colors.red
                              : ColorGlobal.blueColor,
                        ),
                        ShowDetailTextWidget(
                          hintText: 'Phone Number',
                          controller: phone,
                          type: 'phone',
                          color: color[4] == 0
                              ? Colors.red
                              : ColorGlobal.blueColor,
                        ),
                            ShowDetailTextWidget(
                              hintText: 'Organization',
                              controller: organization,
                              color: color[5] == 0
                                  ? Colors.red
                                  : ColorGlobal.blueColor,
                            ),
                            ShowDetailTextWidget(
                              hintText: 'Position',
                              controller: position,
                              color: color[6] == 0
                                  ? Colors.red
                                  : ColorGlobal.blueColor,
                            ),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: DropDown(
                                  select: 0,
                                  hint: branch.text,
                                  branches: allBranch,
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
                              flex: 2,
                            ),
                          ],
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
                        StreamBuilder<double>(
                            stream: _bloc.stream,
                            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                              print('is keyboard open: ${_bloc.keyboardUtils.isKeyboardOpen}'
                                  'Height: ${_bloc.keyboardUtils.keyboardHeight}');
                              return Container(height: _bloc.keyboardUtils.keyboardHeight,);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
          ),
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
  final dynamic branches;
  static String branch;
  static int year;
  static String emirate;
  static String gender;

  DropDown({Key key, this.select, this.hint, this.branches}) : super(key: key);

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
    var year = DateTime
        .now()
        .year;
    for (var i = year; i >= 1964; i--)
      all.add(i);
    return all;
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print('${widget.select}\n');
//    print(_branch);
//    print(all);
    if (widget.select == 0) {
      return widget.branches!=null? DropdownButtonHideUnderline(
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
              if (!mounted) return; setState(() {
                _branch = newValue;
                DropDown.branch = newValue;
              });
            },
            items:  widget.branches.map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ) : Text(DropDown.branch);
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
              if (!mounted) return; setState(() {
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
              if (!mounted) return; setState(() {
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
              if (!mounted) return; setState(() {
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