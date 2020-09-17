import 'package:chatapp/Configs/app_constants.dart';
import 'package:chatapp/Utils/color_detector.dart';
import 'package:chatapp/Utils/theme_management.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

setStatusBarColor(SharedPreferences prefs) {
  if (Thm.isDarktheme(prefs) == true) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: chatappAPPBARcolorDarkMode,
        statusBarIconBrightness: isDarkColor(chatappAPPBARcolorDarkMode)
            ? Brightness.light
            : Brightness.dark));
  } else {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: chatappAPPBARcolorLightMode,
        statusBarIconBrightness: isDarkColor(chatappAPPBARcolorLightMode)
            ? Brightness.light
            : Brightness.dark));
  }
}
