import 'package:testing/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:googleapis/gmail/v1.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:testing/models/priority_handler.dart';

class GmailMessage{
  int maxMsg = 10;
  int id = 0;
  var messagesList = <Message>[];
  var senderList = <String>[];
  var emailIds = <String>[];
  var userList = <UserData>[];
  var messages = <AppMessage>[];
  var priorityHandler = PriorityHandler();
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
    int hh = int.parse(hhMmSs[0])+12;
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

  Future<void> buildAppMessage(String emailId,Message messageData, DirectoryApi directoryApi) async {
    String text = stringToBase64Url.decode(messageData.payload?.parts?.first.body?.data ?? '');
    debugPrint(messageData.payload?.mimeType ?? '');
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
    String emailAdd = temp[1];
    String userName = temp[0];
    bool flag1 = false;
    if(!senderList.contains(userName)){
      id += 1;
      senderList.add(userName);
      emailIds.add(emailAdd);
      flag1 = true;
    }
    senderData = UserData(id: id, name: userName,imageUrl: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),emailId: emailId);
    if(flag1){
      userList.add(senderData);
    }
    final appMessageData = AppMessage(id:emailId,sender: senderData, time: time, datetime: dateTime, date: date, text: text, subject: subject, isStarred: false, unread: false, priority: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.5));
    debugPrint(senderData.name);
    messages.add(appMessageData);
  }

  Future<String> fetchMessages(GmailApi gmailApi, Message message, DirectoryApi directoryApi) async{
    String msg = "";
    String id = message.id ?? "";
    // debugPrint(id);
    Message messageData = await gmailApi.users.messages.get("me",id);
    messagesList.add(messageData);
    await buildAppMessage(id,messageData, directoryApi);
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
    priorityHandler.getPriority(messages);
    // for (var element in messages) {
    //   debugPrint("sorting");
    //   debugPrint(element.date);
    //   debugPrint(element.time);
    //   debugPrint(element.subject);
    // }
  }
}

class AppMessage {
  final String id;
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
    required this.id,
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

