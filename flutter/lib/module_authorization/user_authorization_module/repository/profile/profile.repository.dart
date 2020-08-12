import 'dart:convert';

import 'package:inject/inject.dart';
import 'package:tourists/consts/urls.dart';
import 'package:tourists/module_authorization/user_authorization_module/request/create_profile/create_profile_body.dart';
import 'package:tourists/module_authorization/user_authorization_module/response/create_profile/create_profile_response.dart';
import 'package:tourists/module_network/http_client/http_client.dart';

@provide
class ProfileRepository {
  HttpClient _httpClient;

  ProfileRepository(this._httpClient);

  Future<CreateProfileResponse> createProfile(CreateProfileBody profile) async {
    var stringResponse = await _httpClient.post(Urls.createProfileAPI, profile.toJson());
    if (stringResponse != null) {
      CreateProfileResponse parsedResponse = new CreateProfileResponse.fromJson(jsonDecode(stringResponse));
      return parsedResponse;
    }

    return null;
  }

  Future<CreateProfileResponse> getProfile(String uid) async {
    var stringResponse = await _httpClient.get(Urls.getProfileAPI + '/' + uid);
    if (stringResponse != null) {
      CreateProfileResponse parsedResponse = new CreateProfileResponse.fromJson(json.decode(stringResponse));
      return parsedResponse;
    }

    return null;
  }
}