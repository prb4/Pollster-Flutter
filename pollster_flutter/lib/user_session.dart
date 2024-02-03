import 'package:flutter/material.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();


  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  String username = "";
  int userId = -1;
}