import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lalo/pages/loading.dart';
import 'package:lalo/services/globals.dart';
import 'package:settings_ui/settings_ui.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userRef?.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Friends'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        child: Text(
                          user!.displayName?.substring(0, 2).toUpperCase() ??
                              'HI',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SettingsList(
                        contentPadding: const EdgeInsets.all(10),
                        lightTheme: const SettingsThemeData(
                            settingsListBackground: Colors.white),
                        darkTheme: SettingsThemeData(
                            settingsListBackground: Colors.grey[900]),
                        sections: [
                          SettingsSection(
                              tiles: snapshot.data['permissions']
                                  .map((i) {
                                    return SettingsTile.navigation(
                                        title: Text(i['name']),
                                        value: const Text(
                                            'Tap to remove this friend'),
                                        leading: const Icon(
                                            Icons.account_circle_outlined),
                                        onPressed: (context) {
                                          userRef?.update({
                                            'permissions':
                                                FieldValue.arrayRemove([i])
                                          });
                                        },
                                        trailing: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: fromHex(i['color']),
                                          ),
                                        ));
                                  })
                                  .toList()
                                  .cast<AbstractSettingsTile>())
                        ]),
                  ),
                  const Expanded(
                    child: Text(
                        'Here are all the friends who\'s requests you accepted!'),
                  )
                ],
              ),
            );
          } else {
            return const LoadingScreen();
          }
        });
  }
}
