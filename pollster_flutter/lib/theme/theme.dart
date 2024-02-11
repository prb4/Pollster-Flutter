import 'package:flutter/material.dart';
import 'package:pollster_flutter/theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    
    //elevatedButtonTheme: ElevatedButtonThemeData
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme
  );
}