import 'package:flutter/material.dart';
import 'package:testing/models/message_model.dart';
import 'package:testing/tabs/mailpage.dart';
import 'package:testing/tabs/compose.dart';
import 'package:testing/tabs/frontpage.dart';
import 'dart:math';
import 'package:flutter/rendering.dart';

import 'drawer.dart';

shortUsername(username) {
  String uname = username.toString();
  int length = 26;
  if(uname.length >= length){
    return uname.substring(0,length)+"...";
  }else{
    return uname;
  }
}

initialCheck(name){
  if(name.length >0 && (name[0] == "\"" || name[0] == "\'")){
    return initialCheck(name.substring(1));
  }
  return name;
}

class Mails extends StatefulWidget {
  @override
  _MailsState createState() => _MailsState();
}

class _MailsState extends State<Mails> {
  ScrollController _scrollController = new ScrollController();
  static final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool show = true;
  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      show = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      show = false;
    });
  }

  void handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      key: _key,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.jpg"),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(

                padding:EdgeInsets.fromLTRB(15,0,15,5) ,
                sliver: SliverAppBar(
                  toolbarHeight: 55,
                  primary: false,
                  backgroundColor: Colors.blue,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: TextBox(),
                  elevation: 2,
                  floating: true,
                  shape: ContinuousRectangleBorder(
                    side : BorderSide(width: 1,color: Colors.blue.shade200),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                        topRight:Radius.circular(22),
                        topLeft:Radius.circular(22)),

                  ),
                  actions: <Widget>[
                    Container(
                      width: 65,
                      child: PopupMenuButton<String>(
                        icon: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/sahil.jpg')),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: currentUser?.displayName ?? '',
                              child: Text(currentUser?.email ?? ''),
                            ),
                          ];
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                        child: Text('INBOX',
                            style:
                            TextStyle(color: Colors.grey[800], fontSize: 12.5)),
                      );
                    }
                    return Dismissible(
                        background: Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            color: Colors.green[900],
                            child: Icon(
                              Icons.archive_outlined,
                              color: Colors.yellow,
                              size: 30,
                            )),
                        secondaryBackground: Container(
                            padding: EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            color: Colors.green[900],
                            child: Icon(Icons.archive_outlined,
                                color: Colors.white, size: 30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: gmailMessage.messages[index - 1].priority,
                              ),
                              margin: EdgeInsets.only(
                                  top: 3.0, bottom: 3.0, right: 0.0, left: 5.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: gmailMessage.messages[index - 1].sender.imageUrl,
                                    child: Text(
                                      initialCheck(gmailMessage.messages[index - 1].sender.name)[0],
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    radius: 24.0,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Gmail(
                                              index: index,
                                              user: gmailMessage.messages[index - 1].sender,
                                              image: gmailMessage.messages[index - 1]
                                                  .sender
                                                  .imageUrl,
                                              time: gmailMessage.messages[index - 1].time,
                                              text: gmailMessage.messages[index - 1].text,
                                              subject: gmailMessage.messages[index - 1].subject,
                                              isstarred:
                                              gmailMessage.messages[index - 1].isStarred,
                                            ))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        gmailMessage.messages[index - 1].unread
                                            ? Text(
                                          shortUsername(gmailMessage.messages[index - 1].sender.name),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        )
                                            : Text(
                                          shortUsername(gmailMessage.messages[index - 1].sender.name),
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.6,
                                          child: gmailMessage.messages[index - 1].unread
                                              ? Text(
                                            gmailMessage.messages[index - 1].subject,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                              : Text(
                                            gmailMessage.messages[index - 1].subject,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.6,
                                          child: Text(
                                            gmailMessage.messages[index - 1].text,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: List.generate(2, (i) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Colors.amber[600],
                                                ),
                                                alignment: Alignment.center,
                                                child: Text('Label',
                                                  style: TextStyle(fontSize: 12.0),),
                                                margin: const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                height: 20.0,
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(gmailMessage.messages[index - 1].time),
                                SizedBox(
                                  height: 7.0,
                                ),
                                IconButton(
                                  constraints: BoxConstraints(),
                                  icon: gmailMessage.messages[index - 1].isStarred
                                      ? Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  )
                                      : Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 25.0,
                                  tooltip: 'Star message',
                                  onPressed: () => {
                                    setState(() => {
                                      gmailMessage.messages[index - 1].isStarred =
                                      !gmailMessage.messages[index - 1].isStarred,
                                    }),
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            AppMessage deletedItem = gmailMessage.messages.removeAt(index - 1);
                            _key.currentState;
                            // ..removeCurrentSnackBar()
                            // ..showSnackBar(
                            //   SnackBar(
                            //     content: Text("1 Archieved",style: TextStyle(color: Colors.white),),
                            //     action: SnackBarAction(
                            //         label: "UNDO",
                            //         onPressed: () => setState(() => gmailMessage.messages.insert(index-1, deletedItem),) // this is what you needed
                            //     ),
                            //   ),
                            // );

                          });
                        }

                    );
                  },
                  childCount: gmailMessage.messages.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: show == true
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => Compose()));
        },
        label: Text('Compose'),
        icon: Icon(Icons.edit),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        tooltip: 'Upload',
      )
          : FloatingActionButton(
        child: Icon(
          Icons.edit,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => Compose()));
        },
      ),
    );
  }

  Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        cursorHeight: 20,
        decoration: InputDecoration(
          hintText: 'Search in mail',
          border: InputBorder.none,
        ),
        onTap: () {
          showSearch(context: context, delegate: Datasearch());
        },
      ),
    );
  }
}

class Datasearch extends SearchDelegate<String> {
  final names = gmailMessage.senderList;
  final recentSearches = [
    '111801055@smail.iitpkd.ac.in',
    '111801035@smail.iitpkd.ac.in',
    '111801040@smail.iitpkd.ac.in',
    'sjchaudhari23@gmail.com',
    'albert@iitpkd.ac.in',
    'academics@iitpkd.ac.in'
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [

      IconButton(
        icon: Icon(Icons.mic),
        onPressed: () {},
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : names.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.person_search),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}



























