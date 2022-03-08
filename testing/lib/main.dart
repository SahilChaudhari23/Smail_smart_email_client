import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:testing/message_model.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn.standard(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    GmailApi.gmailReadonlyScope,
  ],
);

List<Message> messagesList = [];

void main() {
  runApp(
    const MaterialApp(
      title: 'Google Sign In',
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
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
    var msg = '';
    int maxResults = gmailMessage.maxMsg;
    setState(() {
      _mails = 'Loading mails...';
    });
    ListMessagesResponse results = await gmailApi.users.messages.list("me", maxResults:maxResults);
    // Profile profile = (await gmailApi.users.getProfile("me"));
    // msg += results.messages?.first.toJson().toString() ?? 'no data1';
    int count = 0;
    results.messages?.forEach((Message message) async{
      if(message.id != null){
        var msg1 = (await gmailMessage.fetchMessages(gmailApi, message));
        msg += msg1;
      }
      count++;
      debugPrint(count.toString());

      if(count == maxResults){
        if (msg != '') {
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

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_mails),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          ElevatedButton(
            child: const Text('REFRESH'),
            onPressed: () => {_handleGmail(user)},
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: SingleChildScrollView(
          // constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}