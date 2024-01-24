import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:technical_code_challenge/core/constant.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

import '../utils/auth_provider.dart';


class ApiClient {

  static String? accessToken;

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    final String ua = await userAgent();

    try {
      final response = await http.post(
        Uri.parse(registrationUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': ua,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Received non-successful status code: ${response.statusCode}'};
      }
    } on http.ClientException catch (e) {
      return {'error': 'Network error occurred. Please check your internet connection.'};
    } catch (e) {

      return {'error': 'An unexpected error occurred during registration.'};
    }
  }


  Future<Map<String, dynamic>> login(String username, String password, BuildContext context) async {
    final String ua = await userAgent();

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': ua,
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData.containsKey('access_token')) {
          String accessToken = responseData['access_token'];
          Provider.of<AuthProvider>(context, listen: false).setAccessToken(accessToken);
          return responseData;
        } else {
          return {'error': 'Invalid response structure: Missing access_token'};
        }
      } else if (response.statusCode == 401) {
        return {'error': 'Invalid username or password'};
      } else {
        return {'error': 'Received non-successful status code: ${response.statusCode}'};
      }
    } on http.ClientException catch (e) {
      return {'error': 'Network error occurred. Please check your internet connection.'};
    } catch (e) {
      return {'error': 'An unexpected error occurred during login.'};
    }
  }



  Future<dynamic> logout(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(logoutUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {'error': 'An error occurred during logout.'};
    }
  }


  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
  final String apiUrl = 'http://62.171.137.149:30080/authentication/change-password';
  final String accessToken = "MY_ACCESS_TOKEN_FROM_LOGIN"; 

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', 
      },
    );

    print('Received response from change password API: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return {'status': 'success', 'message': 'Password changed successfully'};
    } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403 || response.statusCode == 404 || response.statusCode == 500) {
      Map<String, dynamic> errorResponse = jsonDecode(response.body);

      if (errorResponse.containsKey('code') && errorResponse.containsKey('message')) {
        return {'status': 'error', 'code': errorResponse['code'], 'message': errorResponse['message']};
      } else {
        return {'status': 'error', 'message': 'An unexpected error occurred'};
      }
    } else {
      return {'status': 'error', 'message': 'An unexpected error occurred'};
    }
  } catch (e) {
    print('Error during password change: $e');
    return {'status': 'error', 'message': 'An error occurred during password change.'};
  }

  String getUsernameFromToken(String token) {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      if (decodedToken.containsKey('sub')) {
        return decodedToken['sub'];
      }
      return '';
    } catch (e) {
      print('Error decoding JWT token: $e');
      return '';
    }
  }

}
