
import 'dart:convert';
import 'dart:io';

import 'ResponseBody.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'package:iosrecal/constants/Api.dart';

class LoginData {
  LoginData({this.email, this.password, this.user});
  String email;
  String password;
  User user;

  Future<void> _loginUser(String email, String password) async {
    email = email.trim();
    password = password.trim();
    bool internetConnection=false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetConnection=true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    if(internetConnection==true) {
      var url = Api.login;
      var body = {
        'email': email,
        'password': password
      };
      await http
          .post(
        url,
        body: body,
      )
          .then((_response) async {
        ResponseBody responseBody =
        new ResponseBody();
        print('Response body: ${_response.body}');

        if (_response.statusCode == 200) {
          responseBody = ResponseBody.fromJson(
              json.decode(_response.body));
          print(json.encode(responseBody.data));
          if (responseBody.status_code == 200) {
            String rawCookie =
            _response.headers['set-cookie'];
            String cookie = rawCookie.substring(
                0, rawCookie.indexOf(';'));
            print(cookie);
            user = User.fromLogin(json.decode(
                json.encode(responseBody.data)));
            user.cookie = cookie;
            return user;
          } else {
            print(responseBody.data);
            return user;
          }
        } else {
          print("server error");
          return user;
        }
      });
    }
    else {
      user = new User();
      user.user_id=-1;
      return user;
    }
  }

  Future<Null> loginUser (String email, String password) async {
    await _loginUser(email, password);
  }
}