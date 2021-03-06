import 'package:testing/models/user_model.dart';
// import 'package:testing/models/message_model.dart';
import 'package:testing/tabs/mails.dart';
import 'package:testing/tabs/frontpage.dart';
import 'package:flutter/material.dart';
import 'package:testing/tabs/reply.dart';
import 'package:testing/tabs/tts.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

shortUsername(username) {
  String uname = username.toString();
  if(uname.length >= 12){
    return uname.substring(0,12)+"...";
  }else{
    return uname;
  }
}

// ignore: must_be_immutable
class Gmail extends StatefulWidget {
  final int index;
  final UserData user;
  final Color image;
  final String time;
  final String text;
  final String subject;
  bool isstarred;

  Gmail(
      {
        required this.index,
        required this.user,
        required this.image,
        required this.time,
        required this.text,
        required this.subject,
        required this.isstarred
      });

  @override
  _GmailState createState() => _GmailState();
}

class _GmailState extends State<Gmail> {
  bool _hasBeenPressed = false;

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
  
   GlobalKey _key2 = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizes();
    //_getPositions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _key2,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {}),
          IconButton(icon: Icon(Icons.delete), onPressed: () {
            gmailMessage.messages.removeAt(widget.index - 1);
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (builder) => Mails()));
             } 
          ),
          IconButton(icon: Icon(Icons.mail), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (builder) => Mails()));
          }),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Move  to"),
                  value: "moveto",
                ),
                PopupMenuItem(
                  child: Text("Snooze"),
                  value: "snooze",
                ),
                PopupMenuItem(
                  child: Text("Mark Important"),
                  value: "mark_imp",
                ),
                PopupMenuItem(
                  child: Text("Change Priority"),
                  value: "change_p",
                ),
                PopupMenuItem(
                  child: Text("Config labels"),
                  value: "cfg_lable",
                ),
                PopupMenuItem(
                  child: Text("Mute"),
                  value: "mute",
                ),
                PopupMenuItem(
                  child: Text("Report Spam"),
                  value: "report_spam",
                ),
                PopupMenuItem(
                  child: Text("Add to tasks"),
                  value: "add_to_tasks",
                ),
                PopupMenuItem(
                  child: Text("Help & Feedback"),
                  value: "help",
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              //subject part
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    key: _key2,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 70,
                    child: Text(
                      widget.subject,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(children: [
                    Container(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                          'Inbox',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: _hasBeenPressed
                          ? Icon(
                              Icons.star,
                              color: Colors.yellow,
                            )
                          : Icon(Icons.star_border_outlined),
                      iconSize: 30.0,
                      tooltip: 'Star message',
                      onPressed: () => {
                        setState(() => {
                              _hasBeenPressed = !_hasBeenPressed,
                            }),
                      },
                    ),
                  ])
                ],
              ),

              //Mail name part -----> round box
              SizedBox(
                height: 16.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 45.0,
                      width: 45.0,
                      decoration: BoxDecoration(
                          color: Colors.pink[400], shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          widget.user.name[0],
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Cinzel',
                          ),
                        ),
                      )),

                  SizedBox(
                    width: 10.0,
                  ),

                  //Mail name part -----> Name part
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              shortUsername(widget.user.name),
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 11.0),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'to me',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 14.0),
                          ),
                          Icon(Icons.expand_more),
                        ],
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.reply),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Reply(
                                      index: 1,
                                      title: "Reply",
                                      user: widget.user.name,
                                      subject: widget.subject,
                                      msg: widget.text,
                                      time: widget.time)));
                        },
                      ),
                      PopupMenuButton<String>(
                        //offset: Offset(10, 40),
                        onSelected: (value) {
                          print(value);
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              child: Text("Reply all"),
                              value: "Reply all",
                            ),
                            PopupMenuItem(
                              child: Text("Forward"),
                              value: "Forward",
                            ),
                            PopupMenuItem(
                              child: Text("Add star"),
                              value: "Add star",
                            ),
                            PopupMenuItem(
                              child: Text("Print"),
                              value: "Print",
                            ),
                            PopupMenuItem(
                              child: Text("Mark unread"),
                              value: "Mark unread from here",
                            ),
                            PopupMenuItem(
                              child: Text("Block linkedln"),
                              value: "Block linkedln",
                            ),
                          ];
                        },
                      ),


                      //Icon(Icons.more_vert),
                    ],
                  )
                ],
              ),
              SizedBox(height: 40),
              Wrap(
                children: [
                  Row(
                    children: [
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(10, 0, 2, 15),
                      //   height: 300,
                      //   width: 300,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //         image: AssetImage('assets/liner.jpg'),
                      //         fit: BoxFit.fill,
                      //       ),
                      //       shape: BoxShape.circle),
                      // ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Container(
                  //   height: 150,
                  //   width: 350,
                  //   margin: EdgeInsets.only(top: 12, bottom: 8),
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/sugar.png'),
                  //         fit: BoxFit.fitWidth),
                  //     shape: BoxShape.rectangle,
                  //   ),
                  // ),
                  //SizedBox(height: 10),

                ],
              )
            ], //children
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(Icons.access_alarm_outlined, "Alarm", 1, widget.user.name, widget.subject,
                  widget.text, widget.time),
              button(Icons.calendar_today_rounded, "Event", 2, widget.user.name,
                  widget.subject, widget.text, widget.time),
              button(Icons.speaker_phone, "Text to Speech", 3, widget.user.name,
                  widget.subject, widget.text, widget.time),
            ],
          ),
        ),
      ),
    );
  }

  _getSizes() {
    final RenderObject? renderBoxRed = _key2.currentContext?.findRenderObject();
    final sizeText = renderBoxRed?.depth;
    print("SIZE of Text: $sizeText");
  }

  Widget button(IconData icon, String text, int index, String name,
      String subject, String msg, String time) {
    if(text == "Text to Speech"){
      return SizedBox(
        height: 46,
        child: OutlineButton.icon(
          color: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => TTS(widget.text)));
          },
          icon: Icon(icon),
          label: Text((text), style: TextStyle(color: Colors.grey[800])),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.grey.shade400)),
        ),
      );
    }else{
      if(text == "Alarm"){
        return SizedBox(
          height: 46,
          child: OutlineButton.icon(
            color: Colors.amber,
            onPressed: () {
              _openClock();
            },
            icon: Icon(icon),
            label: Text((text), style: TextStyle(color: Colors.grey[800])),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey.shade400)),
          ),
        );
      }else{
        return SizedBox(
          height: 46,
          child: OutlineButton.icon(
            color: Colors.lightBlueAccent,
            onPressed: () {
              _openCalendar();
            },
            icon: Icon(icon),
            label: Text((text), style: TextStyle(color: Colors.grey[800])),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey.shade400)),
          ),
        );
      }
    }
  }
}
