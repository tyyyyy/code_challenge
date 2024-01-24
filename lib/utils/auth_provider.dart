import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  AuthProvider();

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
    print('Access Token Set: $_accessToken');
    notifyListeners();
  }

}
