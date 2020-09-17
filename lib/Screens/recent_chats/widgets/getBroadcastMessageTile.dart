import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/Configs/Dbkeys.dart';
import 'package:chatapp/Configs/Dbpaths.dart';
import 'package:chatapp/Configs/app_constants.dart';
import 'package:chatapp/Models/DataModel.dart';
import 'package:chatapp/Screens/Broadcast/BroadcastChatPage.dart';
import 'package:chatapp/Screens/call_history/callhistory.dart';
import 'package:chatapp/Screens/recent_chats/RecentsChats.dart';
import 'package:chatapp/Screens/recent_chats/widgets/getLastMessageTime.dart';
import 'package:chatapp/Services/localization/language_constants.dart';
import 'package:chatapp/Utils/color_detector.dart';
import 'package:chatapp/Utils/theme_management.dart';
import 'package:chatapp/Utils/unawaited.dart';
import 'package:chatapp/Utils/late_load.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget broadcastMessageTile(
    {required BuildContext context,
    required List<Map<String, dynamic>> streamDocSnap,
    required int index,
    required String currentUserNo,
    required SharedPreferences prefs,
    required DataModel cachedModel}) {
  showMenuForBroadcastChat(
    contextForDialog,
    var broadcastDoc,
  ) {
    List<Widget> tiles = List.from(<Widget>[]);

    tiles.add(Builder(
        builder: (BuildContext popable) => ListTile(
            dense: true,
            leading: Icon(Icons.delete, size: 22),
            title: Text(
              getTranslated(popable, 'deletebroadcast'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(prefs)
                        ? chatappDIALOGColorDarkMode
                        : chatappDIALOGColorLightMode),
              ),
            ),
            onTap: () async {
              Navigator.of(popable).pop();
              unawaited(showDialog(
                builder: (BuildContext context) {
                  return Builder(
                      builder: (BuildContext dialogcontext) => AlertDialog(
                            backgroundColor: Thm.isDarktheme(prefs)
                                ? chatappDIALOGColorDarkMode
                                : chatappDIALOGColorLightMode,
                            title: new Text(
                              getTranslated(dialogcontext, 'deletebroadcast'),
                              style: TextStyle(
                                color: pickTextColorBasedOnBgColorAdvanced(
                                    Thm.isDarktheme(prefs)
                                        ? chatappDIALOGColorDarkMode
                                        : chatappDIALOGColorLightMode),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Text(
                                  getTranslated(dialogcontext, 'cancel'),
                                  style: TextStyle(
                                      color: chatappPRIMARYcolor,
                                      fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.of(dialogcontext).pop();
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Text(
                                  getTranslated(dialogcontext, 'delete'),
                                  style: TextStyle(
                                      color: chatappREDbuttonColor,
                                      fontSize: 18),
                                ),
                                onPressed: () async {
                                  String broadcastID =
                                      broadcastDoc[Dbkeys.broadcastID];
                                  Navigator.of(dialogcontext).pop();

                                  Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () async {
                                    await FirebaseFirestore.instance
                                        .collection(
                                            DbPaths.collectionbroadcasts)
                                        .doc(broadcastID)
                                        .get()
                                        .then((doc) async {
                                      await doc.reference.delete();
                                      //No need to delete the media data from here as it will be deleted automatically using Cloud functions deployed in Firebase once the .doc is deleted .
                                    });
                                  });
                                },
                              )
                            ],
                          ));
                },
                context: context,
              ));
            })));

    showDialog(
        context: contextForDialog,
        builder: (contextForDialog) {
          return SimpleDialog(
              backgroundColor: Thm.isDarktheme(prefs)
                  ? chatappDIALOGColorDarkMode
                  : chatappDIALOGColorLightMode,
              children: tiles);
        });
  }

  return streamLoadCollections(
      stream: FirebaseFirestore.instance
          .collection(DbPaths.collectionbroadcasts)
          .doc(streamDocSnap[index][Dbkeys.broadcastID])
          .collection(DbPaths.collectionbroadcastsChats)
          .orderBy(Dbkeys.timestamp, descending: true)
          .limit(1)
          .snapshots(),
      placeholder: Column(
        children: [
          ListTile(
            onLongPress: () {
              showMenuForBroadcastChat(context, streamDocSnap[index]);
            },
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            leading: customCircleAvatarBroadcast(
                url: streamDocSnap[index][Dbkeys.broadcastPHOTOURL],
                radius: 22),
            title: Text(
              streamDocSnap[index][Dbkeys.broadcastNAME],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(prefs)
                        ? chatappBACKGROUNDcolorDarkMode
                        : chatappBACKGROUNDcolorLightMode),
                fontWeight: FontWeight.w500,
                fontSize: 16.4,
              ),
            ),
            subtitle: Text(
              '${streamDocSnap[index][Dbkeys.broadcastMEMBERSLIST].length} ${getTranslated(context, 'recipients')}',
              style: TextStyle(
                color: chatappGrey,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new BroadcastChatPage(
                          model: cachedModel,
                          prefs: prefs,
                          currentUserno: currentUserNo,
                          broadcastID: streamDocSnap[index]
                              [Dbkeys.broadcastID])));
            },
          ),
          Divider(height: 0),
        ],
      ),
      noDataWidget: Column(
        children: [
          ListTile(
            onLongPress: () {
              showMenuForBroadcastChat(context, streamDocSnap[index]);
            },
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            leading: customCircleAvatarBroadcast(
                url: streamDocSnap[index][Dbkeys.broadcastPHOTOURL],
                radius: 22),
            title: Text(
              streamDocSnap[index][Dbkeys.broadcastNAME],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: pickTextColorBasedOnBgColorAdvanced(
                    Thm.isDarktheme(prefs)
                        ? chatappBACKGROUNDcolorDarkMode
                        : chatappBACKGROUNDcolorLightMode),
                fontWeight: FontWeight.bold,
                fontSize: 16.4,
              ),
            ),
            subtitle: Text(
              '${streamDocSnap[index][Dbkeys.broadcastMEMBERSLIST].length} ${getTranslated(context, 'recipients')}',
              style: TextStyle(
                color: chatappGrey,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new BroadcastChatPage(
                          model: cachedModel,
                          prefs: prefs,
                          currentUserno: currentUserNo,
                          broadcastID: streamDocSnap[index]
                              [Dbkeys.broadcastID])));
            },
          ),
          Divider(height: 0),
        ],
      ),
      onfetchdone: (events) {
        return Column(
          children: [
            ListTile(
              onLongPress: () {
                showMenuForBroadcastChat(context, streamDocSnap[index]);
              },
              contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              leading: customCircleAvatarBroadcast(
                  url: streamDocSnap[index][Dbkeys.broadcastPHOTOURL],
                  radius: 22),
              title: Text(
                streamDocSnap[index][Dbkeys.broadcastNAME],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: pickTextColorBasedOnBgColorAdvanced(
                      Thm.isDarktheme(prefs)
                          ? chatappBACKGROUNDcolorDarkMode
                          : chatappBACKGROUNDcolorLightMode),
                  fontWeight: FontWeight.w500,
                  fontSize: 16.4,
                ),
              ),
              subtitle: Text(
                '${streamDocSnap[index][Dbkeys.broadcastMEMBERSLIST].length} ${getTranslated(context, 'recipients')}',
                style: TextStyle(
                  color: lightGrey,
                  fontSize: 14,
                ),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      getLastMessageTime(context, currentUserNo,
                          events.last[Dbkeys.timestamp]),
                      style: TextStyle(
                          color: lightGrey,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new BroadcastChatPage(
                            model: cachedModel,
                            prefs: prefs,
                            currentUserno: currentUserNo,
                            broadcastID: streamDocSnap[index]
                                [Dbkeys.broadcastID])));
              },
            ),
            Divider(height: 0),
          ],
        );
      });
}
