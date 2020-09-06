import 'dart:async';

import 'package:iosrecal/models/User.dart';
import 'package:iosrecal/repositories/user_api_client.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final UserApiClient userApiClient;

  UserRepository({@required this.userApiClient})
      : assert(userApiClient != null);

  Future<User> fetchUserProfile(List <String> list) async {
    return await userApiClient.fetchUserProfile(list[0], list[1]);
  }
}