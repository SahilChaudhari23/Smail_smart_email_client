import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';


class Config extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Config> {
  _openCalendar () async {
    await LaunchApp.openApp(
      androidPackageName: 'com.google.android.calendar',
      iosUrlScheme: 'googlecalendar://',
      appStoreLink:
      'https://play.google.com/store/apps/details?id=com.google.android.calendar',
      // openStore: false
    );
  }

  _openClock () async {
    await LaunchApp.openApp(
      androidPackageName: 'com.google.android.deskclock&hl=en_IN&gl=US',
      iosUrlScheme: 'googleclock://',
      appStoreLink:
      'https://play.google.com/store/apps/details?id=com.google.android.deskclock&hl=en_IN&gl=US',
      // openStore: false
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter FlatButton Example'),
          ),
          body: Center(child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('SignUp', style: TextStyle(fontSize: 20.0),),
                onPressed: () {
                  _openCalendar();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Text('LogIn', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  _openClock();
                },
              ),
            ),
          ]
          ))
      ),
    );
  }
}

