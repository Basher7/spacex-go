import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_model.dart';
import '../../widgets/separator.dart';

/// SETTINGS SCREEN
/// Here lays all available options for the user to configurate.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = false;
  bool _oledBlack = false;

  bool _sans = false;

  @override
  void initState() {
    Themes _theme = ScopedModel.of<AppModel>(context)?.theme ?? Themes.dark;
    Fonts _font = ScopedModel.of<AppModel>(context)?.font ?? Fonts.normal;

    if (_theme == Themes.light)
      setState(() {
        _darkTheme = false;
        _oledBlack = false;
      });
    else if (_theme == Themes.black)
      setState(() {
        _darkTheme = true;
        _oledBlack = true;
      });
    else
      setState(() {
        _darkTheme = true;
        _oledBlack = false;
      });

    setState(() => _sans = _font == Fonts.sans);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(
          context,
          'app.menu.settings',
        )),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => ListView(
              children: <Widget>[
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.dark_theme.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.dark_theme.body',
                  )),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _darkTheme,
                    onChanged: (value) => _changeTheme(
                          model: model,
                          theme: value
                              ? _oledBlack ? Themes.black : Themes.dark
                              : Themes.light,
                        ),
                  ),
                ),
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.oled_black.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.oled_black.body',
                  )),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _oledBlack,
                    onChanged: (value) => _changeTheme(
                          model: model,
                          theme: value ? Themes.black : Themes.dark,
                        ),
                  ),
                ),
                Separator.divider(height: 0, indent: 16),
                ListTile(
                  title: Text(FlutterI18n.translate(
                    context,
                    'settings.joke.title',
                  )),
                  subtitle: Text(FlutterI18n.translate(
                    context,
                    'settings.joke.body',
                  )),
                  trailing: Switch(
                    activeColor: Theme.of(context).accentColor,
                    value: _sans,
                    onChanged: (value) => _changeFont(
                          model: model,
                          font: value ? Fonts.sans : Fonts.normal,
                        ),
                  ),
                ),
                Separator.divider(),
              ],
            ),
      ),
    );
  }

  void _changeTheme({AppModel model, Themes theme}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('theme', theme.index);
    model.theme = theme;
    if (theme == Themes.dark)
      setState(() {
        _darkTheme = true;
        _oledBlack = false;
      });
    else if (theme == Themes.black)
      setState(() {
        _darkTheme = true;
        _oledBlack = true;
      });
    else
      setState(() {
        _darkTheme = false;
        _oledBlack = false;
      });
  }

  void _changeFont({AppModel model, Fonts font}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('font', font.index);
    model.font = font;

    setState(() => _sans = font == Fonts.sans);
  }
}
