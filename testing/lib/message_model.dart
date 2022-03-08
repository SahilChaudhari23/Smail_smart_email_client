import 'package:googleapis/admin/directory_v1.dart';
import 'package:testing/user_model.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'dart:convert';
import 'dart:math' as math;

class GmailMessage{
  int maxMsg = 2;
  int id = 0;
  var messagesList = <Message>[];
  List<String> senderList = [];
  List<UserData> userList = [];
  List<AppMessage> messages = [];
  List<String> headers = ["Subject","Delivered-To","Received","From","Date","To"];
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);

  String incrementMonth(String month){
    String nextMonth = '';
    switch(month){
      case "Jan":{
        nextMonth = "Feb";
        break;
      }
      case "Feb":{
        nextMonth = "Mar";
        break;
      }
      case "Mar":{
        nextMonth = "Apr";
        break;
      }
      case "Apr":{
        nextMonth = "May";
        break;
      }
      case "May":{
        nextMonth = "Jun";
        break;
      }
      case "Jun":{
        nextMonth = "Jul";
        break;
      }
      case "Jul":{
        nextMonth = "Aug";
        break;
      }
      case "Aug":{
        nextMonth = "Sep";
        break;
      }
      case "Sep":{
        nextMonth = "Oct";
        break;
      }
      case "Oct":{
        nextMonth = "Nov";
        break;
      }
      case "Nov":{
        nextMonth = "Dec";
        break;
      }
      case "Dec":{
        nextMonth = "Jan";
        break;
      }
    }
    return nextMonth;
  }

  String enumMonth(String month) {
    int index = 0;
    switch (month) {
      case "Jan":
        {
          index = 1;
          break;
        }
      case "Feb":
        {
          index = 2;
          break;
        }
      case "Mar":
        {
          index = 3;
          break;
        }
      case "Apr":
        {
          index = 4;
          break;
        }
      case "May":
        {
          index = 5;
          break;
        }
      case "Jun":
        {
          index = 6;
          break;
        }
      case "Jul":
        {
          index = 7;
          break;
        }
      case "Aug":
        {
          index = 8;
          break;
        }
      case "Sep":
        {
          index = 9;
          break;
        }
      case "Oct":
        {
          index = 10;
          break;
        }
      case "Nov":
        {
          index = 11;
          break;
        }
      case "Dec":
        {
          index = 12;
          break;
        }
    }
    if(index <= 9){
      return '0'+index.toString();
    }else{
      return index.toString();
    }
  }

  String dateTimeConverter(String day, String month, String year, String time){
    final hhMmSs = time.split(':');
    int mm = int.parse(hhMmSs[1])+30;
    int hh = int.parse(hhMmSs[0])+13;
    int dd = int.parse(day);
    if(dd <= 9){
      day = '0'+day;
    }
    int yy = int.parse(year);
    String newMonth = month;
    List<String> months30 = ["Apr","Jun","Sep","Nov"];
    if(mm >= 60){
      mm = mm % 60;
      hh += 1;
    }
    if(hh >= 24){
      hh = hh % 24;
      if(month == "Feb" && ((((yy % 4) ==0) && (dd == 29)) || (((yy % 4) !=0) && (dd == 28)))){
        day = "01";
        newMonth = incrementMonth(month);
      }else{
        if(months30.contains(month) && dd == 30){
          day = "01";
          newMonth = incrementMonth(month);
        }
        else{
          if(dd == 31){
            day = "01";
            newMonth = incrementMonth(month);
            if(newMonth == "Jan"){
              year = (yy+1).toString();
            }
          }else{
            if(dd <= 8){
              day = "0"+(dd+1).toString();
            }else{
              day = (dd+1).toString();
            }
          }
        }
      }
    }
    String date = day+' '+newMonth+' '+year;
    String newH = hh.toString();
    String newM = mm.toString();
    if(hh <= 9){
      newH = '0'+newH;
    }
    if(mm <= 9){
      newM = '0'+newM;
    }
    String newTime = newH+':'+newM;
    String dateTime = year+enumMonth(newMonth)+day+newH+newM;
    return date+'/'+newTime+'/'+dateTime;
  }

  Future<void> buildAppMessage(Message messageData, DirectoryApi directoryApi) async {
    String text = stringToBase64Url.decode(messageData.payload?.parts?.first.body?.data ?? '');
    String subject = "";
    String sender = "";
    String date = "";
    String time = "";
    String dateTime = "";
    late UserData senderData;
    // RegExp dateTimeExtractor =
    bool flag = true;
    messageData.payload?.headers?.forEach((element){
      if(element.name != null && headers.contains(element.name) && ((element.name == "Received" && flag) || element.name != "Received")){
        if(element.name == "Received"){
          time = element.value ?? "" ;
          if(time != ""){
            final temp = time.split(';')[1].split(',')[1].split(' ');
            String dateTimeData = dateTimeConverter(temp[1], temp[2], temp[3], temp[4]);
            debugPrint(dateTimeData);
            final tempDateTime = dateTimeData.split('/');
            date = tempDateTime[0];
            time = tempDateTime[1];
            dateTime = tempDateTime[2];
          }
          debugPrint(time);
          flag = false;
        }
        if(element.name == "Subject"){
          subject = element.value ?? "No subject" ;
          debugPrint(subject);
        }
        if(element.name == "From"){
          sender = element.value ?? "Unknown";
        }
      }
    });
    final temp = sender.split('>')[0].split('<');
    String emailId = temp[1];
    String userName = temp[0];
    if(!senderList.contains(sender)){
      id += 1;
      senderList.add(sender);
    }
    senderData = UserData(id: id, name: userName,imageUrl: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),emailId: emailId);
    if(!senderList.contains(sender)){
      userList.add(senderData);
    }
    final appMessageData = AppMessage(sender: senderData, time: time, datetime: dateTime, date: date, text: text, subject: subject, isStarred: false, unread: false, priority: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.5));
    debugPrint(senderData.name);
    messages.add(appMessageData);
  }

  Future<String> fetchMessages(GmailApi gmailApi, Message message, DirectoryApi directoryApi) async{
    String msg = "";
    String id = message.id ?? "";
    Message messageData = await gmailApi.users.messages.get("me",id);
    messagesList.add(messageData);
    await buildAppMessage(messageData, directoryApi);
    bool flag = true;
    messageData.payload?.headers?.forEach((element) {
      if(element.name != null && headers.contains(element.name) && ((element.name == "Received" && flag) || element.name != "Received")){
        if(element.name == "Received"){
          flag = false;
        }
        msg += element.name ?? "no name";
        msg += " \n:\n ";
        // msg += stringToBase64Url.decode(element.value ?? "no value");
        msg += element.value ?? "no value";
        msg += "\n...................................................................\n";
      }
    });
    msg += stringToBase64Url.decode(messageData.payload?.parts?.first.body?.data ?? '');
    msg += "\n\n\n\n\nNew mail \n\n\n\n";
    return msg;
  }

  void sortMessages(){
    messages.sort((a,b) => b.datetime.compareTo(a.datetime));
    debugPrint("count : : "+messagesList.length.toString());
    for (var element in messages) {
      debugPrint("sorting");
      debugPrint(element.date);
      debugPrint(element.time);
      debugPrint(element.subject);
    }
  }
}

class AppMessage {
  final UserData sender;
  final String time;
  final String datetime;
  final String date;
  final String text;
  final String subject;
  final Color priority;
  bool isStarred;
  final bool unread;
  AppMessage({
    required this.sender,
    required this.time,
    required this.datetime,
    required this.date,
    required this.text,
    required this.subject,
    required this.isStarred,
    required this.unread,
    required this.priority,
  });
}

// final User currentUser =User(id: 0, name: 'Sahil Chaudhari', imageUrl: Colors.red);
// final User sandhya = User(id: 1, name: 'Sandhya Chandrasekharan', imageUrl: Colors.orange);
// final User acad = User(id: 2, name: 'Academic IIT Palakkad', imageUrl: Colors.grey);
// final User medium = User(id: 3, name: 'Medium Daily', imageUrl: Colors.pink.shade700);
// final User amazon = User(id: 4, name: 'Amazon.in', imageUrl: Colors.yellow);
// final User vishesh = User(id: 5, name: 'Vishesh Munjal', imageUrl: Colors.red);
// final User rajeev = User(id: 6, name: 'Rajeev Goyal', imageUrl:Colors.teal);
// final User leetcode = User(id: 7, name: 'LeetCode', imageUrl: Colors.blueGrey);
// final User digitalocean = User(id: 8, name: 'Digital Ocean', imageUrl: Colors.deepPurpleAccent);
// final User digitalocean1 = User(id: 9, name: 'Digital Ocean', imageUrl: Colors.greenAccent);
// final User digitalocean2 = User(id: 10, name: 'Digital Ocean', imageUrl: Colors.lightBlue);
// final User digitalocean3 = User(id: 11, name: 'Digital Ocean', imageUrl: Colors.amber);
// final User digitalocean4 = User(id: 12, name: 'Digital Ocean', imageUrl: Colors.pink.shade700);

//Chats on Mail Screen

List<AppMessage> mails = [
  // AppMessage(
  //     sender: sandhya,
  //     time: '04:30 PM',
  //     text: 'Can you spot common mistakes to look out for when writing about campus?\n1, Security cameras with adequate backup facilities are installed in the campus.\n2. The first year students have their classes and accomodations in the Ahalia campus.\n3.At the Ahalia campus, the hostels are close to the academic block.\n4.  IIT Palakkad currently functions in two campuses.\n5. The boys and girls have separate hostels with 24/7 Wi-Fi connectivity.\nAnswersregards, Sandhya\n--\nRoom# 203, Academic Block,\nAhalia Campus\nIIT Palakkad',
  //     subject: 'Correct the sentences',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.blueGrey
  // ),
  // AppMessage(
  //     sender: acad,
  //     time: '01:05 PM',
  //     text: 'Dear Students,\nIn continuation to the mail sent, please be informed that the deadline for filling the google form for renewal of scholarships is extended till 13.12.2021 ( Monday ).\nThe google form link can be found here\nPlease note that no further extensions will be given for the same.',
  //     subject: 'Renewal of Scholarships- Income Certificate Submission',
  //     isStarred: true,
  //     unread: false,
  //     priority: Colors.red
  // ),
  // AppMessage(
  //     sender: vishesh,
  //     time: '10:00 AM',
  //     text: 'Check the modified PDF attached & send feedback...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
  //     subject: 'PDF attached',
  //     isStarred: false,
  //     unread: false,
  //     priority: Colors.amberAccent
  // ),
  // AppMessage(
  //     sender: rajeev,
  //     time: '9:30 AM',
  //     text: 'Ive created the collab repo, shall we start making the project?...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
  //     subject: 'Invitation to github collaborator',
  //     isStarred: false,
  //     unread: false,
  //     priority: Colors.greenAccent
  // ),
  // AppMessage(
  //     sender: medium,
  //     time: '9:05 AM',
  //     text: 'Stories for Sahil Chaudhari : How I got an engineering internships in...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
  //     subject: 'Simple SQFlite databases examples in flutter',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.limeAccent
  // ),
  // AppMessage(
  //     sender: amazon,
  //     time: 'Dec 11',
  //     text: 'Amazon Orders|1 of 5 items order has been dispatched...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
  //     subject: 'Your Amazon.in order #205-304458 of 1 item has been dispatched',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.lightBlueAccent
  // ),
  // AppMessage(
  //     sender: leetcode,
  //     time: 'Dec 11',
  //     text: 'Hello!🎉 Congratulations to our 1st leetcodes Pick winner...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
  //     subject: 'Leetcode Weekly Digest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.lightBlueAccent
  // ),
  // AppMessage(
  //     sender: digitalocean,
  //     time: 'Dec 10',
  //     text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  //     subject: 'Dev Badge @Hacktoberfest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.lime
  // ),
  // AppMessage(
  //     sender: digitalocean1,
  //     time: 'Dec 10',
  //     text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  //     subject: 'Dev Badge @Hacktoberfest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.lime
  // ),
  // AppMessage(
  //     sender: digitalocean2,
  //     time: 'Dec 10',
  //     text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  //     subject: 'Dev Badge @Hacktoberfest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.white
  // ),
  // AppMessage(
  //     sender: digitalocean3,
  //     time: 'Dec 10',
  //     text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  //     subject: 'Dev Badge @Hacktoberfest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.lime
  // ),
  // AppMessage(
  //     sender: digitalocean4,
  //     time: 'Dec 10',
  //     text: 'Get your Dev Badge at Hacktoberfest ,just by login into the Dev Website...Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
  //     subject: 'Dev Badge @Hacktoberfest',
  //     isStarred: false,
  //     unread: true,
  //     priority: Colors.white
  // ),
];

