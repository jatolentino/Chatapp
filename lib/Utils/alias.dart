//*************    

import 'dart:io';
import 'package:chatapp/Configs/Dbkeys.dart';
import 'package:chatapp/Configs/app_constants.dart';
import 'package:chatapp/Services/localization/language_constants.dart';
import 'package:chatapp/Models/DataModel.dart';
import 'package:chatapp/Utils/color_detector.dart';
import 'package:chatapp/Utils/theme_management.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AliasForm extends StatefulWidget {
  final Map<String, dynamic> user;
  final DataModel? model;
  final SharedPreferences prefs;
  AliasForm(this.user, this.model, this.prefs);

  @override
  _AliasFormState createState() => _AliasFormState();
}

class _AliasFormState extends State<AliasForm> {
  TextEditingController? _alias;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _alias =
        new TextEditingController(text: chatapp.getNickname(widget.user));
  }

  Future getImage(File image) {
    setState(() {
      _imageFile = image;
    });
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    String? name = chatapp.getNickname(widget.user);
    return AlertDialog(
      backgroundColor: Thm.isDarktheme(widget.prefs)
          ? chatappDIALOGColorDarkMode
          : chatappDIALOGColorLightMode,
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              getTranslated(context, 'removealias'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(widget.prefs)
                        ? chatappDIALOGColorDarkMode
                        : chatappDIALOGColorLightMode),
              ),
            ),
            onPressed: widget.user[Dbkeys.aliasName] != null ||
                    widget.user[Dbkeys.aliasAvatar] != null
                ? () {
                    widget.model!.removeAlias(widget.user[Dbkeys.phone]);
                    Navigator.pop(context);
                  }
                : null),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              getTranslated(context, 'setalias'),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: chatappPRIMARYcolor),
            ),
            onPressed: () {
              if (_alias!.text.isNotEmpty) {
                if (_alias!.text != name || _imageFile != null) {
                  widget.model!.setAlias(
                      _alias!.text, _imageFile, widget.user[Dbkeys.phone]);
                }
                Navigator.pop(context);
              }
            })
      ],
      contentPadding: EdgeInsets.all(20),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 120,
              height: 120,
              child: Stack(children: [
                Center(
                    child: chatapp.avatar(widget.user,
                        image: _imageFile, radius: 50)),
              ])),
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: _alias,
            style: TextStyle(
              color: pickTextColorBasedOnBgColorAdvanced(
                  Thm.isDarktheme(widget.prefs)
                      ? chatappDIALOGColorDarkMode
                      : chatappDIALOGColorLightMode),
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: pickTextColorBasedOnBgColorAdvanced(
                        Thm.isDarktheme(widget.prefs)
                            ? chatappDIALOGColorDarkMode
                            : chatappDIALOGColorLightMode)
                    .withOpacity(0.6),
              ),
              hintText: getTranslated(context, 'aliasname'),
            ),
            validator: (val) {
              if (val!.trim().isEmpty) return getTranslated(context, 'nameem');
              return null;
            },
          )
        ]),
      ),
    );
  }
}
