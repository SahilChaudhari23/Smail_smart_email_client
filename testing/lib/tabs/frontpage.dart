import 'package:flutter/material.dart';
import 'package:testing/tabs/mails.dart';
import 'dart:async';
import 'package:testing/tabs/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:testing/models/message_model.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';


GmailMessage gmailMessage = GmailMessage();
GoogleSignInAccount? currentUser;

final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    DirectoryApi.adminDirectoryUserReadonlyScope,
    GmailApi.gmailReadonlyScope,
  ],
);


class FrontPage extends StatefulWidget {
  @override
  FrontPageState createState() => FrontPageState();
}

class FrontPageState extends State<FrontPage> {
  final List<Widget> _children = [];
  int _currentIndex = 0;
  String _msg = '';
  String _state = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _state = 'init';
    });
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        currentUser = account;
      });
      if (currentUser != null) {
        setState(() {
          _state = 'loading';
        });
        _handleGmail(currentUser!);
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
    // setState(() {
    //   _mails = 'Loading mails...';
    // });
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
            _state = 'loaded';
            _msg = msg;
            _children.add(Mails());
            _children.add(Config());
            _children.add(_signOut());
            return;
          });
        }else{
          _msg = "No mails to show";
          debugPrint(_msg);
          return;
        }
      }
    });
  }


  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Widget _signOut() {
    _handleSignOut();
    return _signIn();
  }

  Widget _signIn() {
    return Scaffold(
      // backgroundColor: Colors.deepOrange[300],
      appBar: AppBar(title: Text('Login Page'),
        backgroundColor: Colors.amber.shade300,
      ),
      body: Center(
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/bg1.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 150.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text('Welcome to SMAIL',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: (){ _handleSignIn();},
                    icon: Image.asset('assets/images/google_logo.png',
                      height: 32,
                      width: 32,),
                    label: Text('Sign in with Google'),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ],
              )
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_state);
    if (_state == 'loading') {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Emails are loading...',
                  style: Theme.of(context).textTheme.headline6,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        )
      );
    }
    if(_msg != ''){
      debugPrint(gmailMessage.messages.first.subject);
      return Scaffold(
        body: _children[_currentIndex],
        // backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue.shade100,
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
              icon: Icon(Icons.settings, size: 35.0),
              label: 'Config',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app_rounded, size: 35.0),
              label: 'Sign-out',
            )
          ],
        ),
      );
    }else{
      if(_state == 'init'){
        return _signIn();
      }else {
        return _signIn();
      }
    }
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