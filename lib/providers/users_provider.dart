import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:roovies/models/firebase_handler.dart';
import 'package:roovies/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User currentUser;

  Future<void> saveUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', currentUser.email);
    preferences.setString('userId', currentUser.userId);
    preferences.setString('idToken', currentUser.idToken);
    preferences.setString('refreshToken', currentUser.refreshToken);
    preferences.setString('expiryDate', currentUser.expiryDate.toString());
  }

  Future<void> removeUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    preferences.remove('userId');
    preferences.remove('idToken');
    preferences.remove('refreshToken');
    preferences.remove('expiryDate');
  }

  Future<String> register(String email, String password) async {
    try {
      currentUser = await FirebaseHandler.instance.register(email, password);
      saveUserData();
      return null;
    } on DioError catch (error) {
      String errorCode = error.response.data['error']['message'];
      if (errorCode == 'EMAIL_EXISTS') {
        return 'The email address is already in use by another account.';
      } else {
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      }
    }
  }

  Future<String> login(String email, String password) async {
    try {
      currentUser = await FirebaseHandler.instance.login(email, password);
      saveUserData();
      return null;
    } on DioError catch (error) {
      String errorCode = error.response.data['error']['message'];
      if (errorCode == 'EMAIL_NOT_FOUND') {
        return 'There is no user record corresponding to this identifier.';
      } else if (errorCode == 'INVALID_PASSWORD') {
        return 'The password is invalid or the user does not have a password';
      } else {
        return 'The user account has been disabled by an administrator.';
      }
    }
  }

  Future<bool> loggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('idToken')) {
      currentUser = User.fromPreferences(preferences);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> refreshTokenIfNecessary() async {
    if (DateTime.now().isAfter(currentUser.expiryDate)) {
      try {
        currentUser = await FirebaseHandler.instance.refreshToken(currentUser);
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return true;
    }
  }
}
