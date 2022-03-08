import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
//import 'package:demo3/models/user_model.dart';

class Reply extends StatefulWidget {
  final int index;
  final String title;
  final String user;
  final String subject;
  final String msg;
  final String time;

  Reply({this.index, this.title, this.user, this.subject, this.msg, this.time});

  @override
  _ReplyState createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  //Widget text1 = Text("This is ");
  bool pressed = false;
  File file;
  var _mails = [
    '111801055@smail.iitpkd.ac.in',
    '111801035@smail.iitpkd.ac.in',
    '111801040@smail.iitpkd.ac.in',
    'sjchaudhari23@gmail.com',
    'albert@iitpkd.ac.in',
    'academics@iitpkd.ac.in'
  ];
  bool isClicked = false;
  String result = "";

  @override
  Widget build(BuildContext context) {
    String reply = "On Sun " +
        widget.time +
        " " +
        widget.user +
        "<" +
        widget.user +
        "-no-reply-456@gmail.com> wrote \n\n " +
        widget.msg;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: "Roboto"),
        ),
        actions: [
          PopupMenuButton<String>(
            offset: Offset(50, 40),
            icon: Icon(
              (Icons.attachment),
              color: Colors.grey[600],
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: '1',
                  child: Text('Attach File'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Insert From Drive'),
                ),
              ];
            },
            onSelected: (value) async {
              //if (value == '1')
              FilePickerResult result = await FilePicker.platform.pickFiles();
              if (result != null) {
                file = File(result.files.single.path);
                print(file);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
            color: Colors.blue[600],
          ),
        PopupMenuButton<String>(
            offset: Offset(0, 40),
            icon: Icon((Icons.more_vert),
            color: Colors.grey[600],),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: '1',
                  child: Text('Schedule Send'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Add from contacts'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Discard'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Save Draft'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Settings'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Help & Feedback'),
                ),
              ];
            },
            onSelected: (value) {}
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
              child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'From',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
                //Expanded(child: drop()),
                Expanded(
                    child: TextFormField(
                  initialValue: '111801055@smail.iitpkd.ac.in',
                  cursorHeight: 18,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                )),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[350], width: 1.0))),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[350], width: 1.0),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'To',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.user,
                    cursorHeight: 22,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            isClicked = !isClicked;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            isClicked
                ? Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[350], width: 1.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text(
                              'Cc',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              cursorHeight: 22,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[350], width: 1.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Text(
                              'Bcc',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              cursorHeight: 22,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[350], width: 1.0),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[350], width: 1.0),
                      ),
                    ),
                  ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: text(widget.index) + widget.subject,
                    cursorHeight: 22,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: text(widget.index),
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
                    keyboardType: TextInputType.text,
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[350], width: 1.0),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorHeight: 24,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        hintText: "Compose",
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 18, color: Colors.grey[700]),
                        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
                    keyboardType: TextInputType.text,
                  ),
                )
              ],
            ),
            Column(children: [
              IconButton(
                icon: Icon(Icons.more_horiz_rounded),
                onPressed: () {
                  setState(() {
                    pressed = !pressed;
                    print("pressed");
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              pressed == true
                  ? Text(
                      reply,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.0,
                      ),
                    )
                  : Text(""),
            ])
          ],
        ),
      ),
    );
  }

  void attachFile(int index) {
    if (index == 1) {}
  }

  String value = "111801054@smail.iitpkd.ac.in";
  Widget drop() {
    return DropdownButtonHideUnderline(
      child: new DropdownButton(
        isExpanded: true,
        value: value,
        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        items: _mails.map((value) {
          return new DropdownMenuItem(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            value = newValue;
          });
          print(value);
        },
      ),
    );
  }

  String text(int index) {
    if (index == 3) {
      result = "Fwd: ";
    } else {
      result = "Re: ";
    }
    return result;
  }
}
