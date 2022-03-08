import 'package:flutter/material.dart';
import 'package:testing/tabs/mails.dart';
import 'package:testing/tabs/meet.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:testing/message_model.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    DirectoryApi.adminDirectoryUserReadonlyScope,
    GmailApi.gmailReadonlyScope,
  ],
);

class FrontPage extends StatefulWidget {
  const FrontPage({required Key key}) : super(key: key);

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [Mails()];
  GoogleSignInAccount? _currentUser;
  GmailMessage gmailMessage = GmailMessage();
  String _mails = '';
  List<Message> messagesList = [];
  List<String> headers = ["Subject","Delivered-To","Received","From","Date","To"];
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGmail(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGmail(GoogleSignInAccount user) async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var gmailApi = GmailApi(httpClient);
    var directoryApi = DirectoryApi(httpClient);
    var msg = '';
    int maxResults = gmailMessage.maxMsg;
    setState(() {
      _mails = 'Loading mails...';
    });
    ListMessagesResponse results = await gmailApi.users.messages.list("me", maxResults:maxResults);
    int count = 0;
    results.messages?.forEach((Message message) async{
      if(message.id != null){
        var msg1 = (await gmailMessage.fetchMessages(gmailApi, message, directoryApi));
        msg += msg1;
      }
      count++;
      debugPrint(count.toString());

      if(count == maxResults){
        if (msg != '') {
          gmailMessage.sortMessages();
          debugPrint("count::::"+gmailMessage.messagesList.length.toString());
          setState(() {
            _mails = msg;
            return;
          });
        }else{
          _mails = "No mails to show";
          return;
        }
      }
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      return;
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),
              child: Stack(
                children: <Widget>[
                  const Icon(
                    Icons.mail,
                    size: 35,
                  ),
                  Positioned(
                    right: 0,
                    top: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: const Text(
                        '9+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
            label: 'Mail',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.video_call, size: 35.0),
            label: 'Meet',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class FloatAppBar extends StatelessWidget with PreferredSizeWidget {
  const FloatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          right: 15,
          left: 15,
          child: Container(
            color: Colors.red,
            child: Row(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                const Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search..."),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}