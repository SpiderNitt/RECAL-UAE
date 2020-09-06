import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iosrecal/models/ResponseBody.dart';
import 'package:meta/meta.dart';
import 'package:iosrecal/models/User.dart';

class UserApiClient {
  final http.Client httpClient;

  UserApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<User> fetchUserProfile(String userId, String cookie) async {
    var url = "https://delta.nitt.edu/recal-uae/api/users/profile/";
    var uri = Uri.parse(url);
    uri = uri.replace(query: "user_id=$userId");

    final response = await this.httpClient.get(
        uri, headers: {'Cookie': cookie});

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }
    ResponseBody responseBody = ResponseBody.fromJson(
        jsonDecode(response.body));
    print(jsonEncode(responseBody.data));
    if (responseBody.status_code == 200)
      return User.fromProfile(json.decode(json.encode(responseBody.data)));
    else
      throw new Exception("${responseBody.data}");
  }
}
