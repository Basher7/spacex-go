import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors.dart';

enum Themes { light, dark, black }
enum Fonts { normal, sans }

/// APP MODEL
/// Specific general settings about the app.
class AppModel extends Model {
  FlutterLocalNotificationsPlugin notifications;

  static List<ThemeData> _themes = [
    ThemeData(
      brightness: Brightness.light,
      fontFamily: _fontData,
      primaryColor: lightPrimaryColor,
      accentColor: lightAccentColor,
      dividerColor: lightDividerColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontData,
      primaryColor: darkPrimaryColor,
      accentColor: darkAccentColor,
      canvasColor: darkBackgroundColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      dividerColor: darkDividerColor,
      dialogBackgroundColor: darkCardColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontData,
      primaryColor: blackPrimaryColor,
      accentColor: blackAccentColor,
      canvasColor: blackBackgroundColor,
      scaffoldBackgroundColor: blackBackgroundColor,
      cardColor: blackCardColor,
      dividerColor: blackDividerColor,
      dialogBackgroundColor: blackCardColor,
    )
  ];
  static final List<String> _fonts = [
    'ProductSans',
    'ComicSans',
  ];

  Fonts _font = Fonts.normal;
  static String _fontData = 'ProductSans';

  get font => _font;
  get fontData => _fontData;

  set font(Fonts font) {
    _font = font;
    fontData = font;
    notifyListeners();
  }

  set fontData(Fonts font) {
    _fontData = _fonts[font.index];
    notifyListeners();
  }

  Themes _theme = Themes.dark;
  ThemeData _themeData = _themes[1];

  get theme => _theme;
  get themeData => _themeData;

  set theme(Themes theme) {
    _theme = theme;
    themeData = theme;
    notifyListeners();
  }

  set themeData(Themes theme) {
    _themeData = _themes[theme.index];
    notifyListeners();
  }

  Future init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Loads the theme
    try {
      theme = Themes.values[prefs.getInt('theme')];
    } catch (e) {
      prefs.setInt('theme', 1);
    }

    // Loads the font
    try {
      font = Fonts.values[prefs.getInt('font')];
    } catch (e) {
      prefs.setInt('font', 0);
    }
    if (DateTime.now().month == 4 && DateTime.now().day == 1)
      prefs.setInt('font', 1);

    // Inits notifications system
    notifications = FlutterLocalNotificationsPlugin();
    notifications.initialize(
      InitializationSettings(
        AndroidInitializationSettings('action_vehicle'),
        IOSInitializationSettings(),
      ),
    );

    await notifications.show(
      0,
      'Don\'t miss the next SpaceX launch!',
      'Falcon Heavy is launching ArabSat 6A to GTO orbit in 30 minutes.',
      NotificationDetails(
        AndroidNotificationDetails(
          'com.chechu.cherry',
          'Launch notifications',
          'Stay up-to-date with upcoming SpaceX launches',
        ),
        IOSNotificationDetails(),
      ),
    );

    notifyListeners();
  }
}
