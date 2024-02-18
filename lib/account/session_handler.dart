import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSessionToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('session_token', token);
}

Future<String?> getSessionToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('session_token');
}

Future<void> clearSessionToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('session_token', "");
  print(await getSessionToken());
}
