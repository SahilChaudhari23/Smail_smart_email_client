import 'package:flutter/material.dart';
import 'package:testing/tabs/join_meet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:share/share.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'drawer.dart';

class Meet extends StatefulWidget {
  const Meet({required Key key}) : super(key: key);
  @override
  _MeetState createState() => _MeetState();
}

class _MeetState extends State<Meet> {
  CarouselController buttonCarouselController = CarouselController();
  int currentIndex = 0;
  List imgs = [
    'assets/google_meet.jpg',
    'assets/google_meet1.jpg',
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Meet',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          SizedBox(
            width: 65,
            child: PopupMenuButton<String>(
              icon: const CircleAvatar(
                  backgroundImage: AssetImage('assets/sahil.jpg')),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: '1',
                    child: Text('1'),
                  ),
                  const PopupMenuItem<String>(
                    value: '2',
                    child: Text('2'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: FlatButton(
                    padding: const EdgeInsets.all(4),
                    color: Colors.blue[700],
                    textColor: Colors.white,
                    height: 40,
                    child: const Text(
                      'New meeting',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 2.0),
                    ),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                    child: FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => Join()));
                  },
                  height: 40,
                  child: Text('Join with a code',
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 1.0)),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10)),
                )),
                const SizedBox(width: 15),
              ],
            ),
            CarouselSlider(
              items: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100.0),
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/google_meet.jpg'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: 200,
                            child: Text(
                              "Get a link you can share",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 25.0),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: 250,
                            child: Text(
                              "Tap New meeting to get a link you can send to people you want to meet with",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100.0),
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/google_meet1.jpg'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: 200,
                            child: Text(
                              "Your meeting is safe",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 25.0),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: 250,
                            child: Text(
                              "No one can join the meeting unless invited or admitted by the host",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15.0),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ),
                  ],
                ),
              ],
              options: CarouselOptions(
                height: 500.0,
                enableInfiniteScroll: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(imgs, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        currentIndex == index ? Colors.redAccent : Colors.green,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return BottomSheetContent();
      },
    );
  }
}

// ignore: must_be_immutable
class BottomSheetContent extends StatelessWidget {
  BottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.link,
                            color: Colors.black,
                          ),
                          title: const Text(
                            'Get a meeting link to share',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            showAlertDialog(context);
                          },
                        ),
                      ],
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.video_call,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Start an instant meeting',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.calendar_today_rounded,
                          color: Colors.black),
                      title: Text(
                        'Schedule in Google Calender',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.close, color: Colors.black),
                      title: Text(
                        'Close',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String link = "https://meet.google.com/vgt-maqh-dvv";
  // String link = "https://";
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget shareBtn = (FlatButton.icon(
      onPressed: () {
        _onShareData(context);
      },
      icon: const Icon(Icons.share),
      minWidth: 20,
      label: const Text('Share'),
      color: Colors.blue[300],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.blue)),
    ));
    // set up the AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 2),
          title: const Text("Here's the link to your meeting"),
          content: Builder(
            builder: (context) {
              var width = MediaQuery.of(context).size.width;

              return SizedBox(
                height: 250,
                width: width,
                child: Column(
                  children: [
                    const Text(
                        "Copy this link and send it to people you want to meet with. Be sure to save it so you can use it later, too.\n"),
                    
                    Text(
                      link,
                      maxLines: 3,
                      style: TextStyle(
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        print("pressed");
                        ClipboardManager.copyToClipBoard(link).then((result) {
                          final snackBar = SnackBar(
                            content: const Text('Copied to Clipboard'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                      },
                    ),
                    shareBtn,
                  ],
                ),
              );
            },
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        );
      },
    );

    // show the dialog
  }

  _onShareData(BuildContext context) async {
    {
      await Share.share(
        link,
      );
    }
  }
}