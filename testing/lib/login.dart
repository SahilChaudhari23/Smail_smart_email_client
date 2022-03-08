import 'package:testing/message_model.dart';
import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';

void debugPrint(List<Message> msgList){

}

class LoginController extends GetxController{
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(scopes: [GmailApi.gmailReadonlyScope]);
  var googleAccount = Rx<GoogleSignInAccount?>(null);
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
  List<Message> messagesList = [];
  List<String> headers = ["Subject","Delivered-To","Received","From","Date","To"];
  String msg = ' ';

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
  }

  getGmailApi() async{
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var gmailApi = GmailApi(httpClient);
    ListMessagesResponse results = await gmailApi.users.messages.list("me", maxResults:10);
    Profile profile = (await gmailApi.users.getProfile("me"));
    results.messages?.forEach((Message message) async{
      if(message.id != null){
        String id = message.id ?? "";
        Message messageData = await gmailApi.users.messages.get("me",id);
        messagesList.add(messageData);
        // msg = messageData.payload?.parts?.first?.body?.data?.toString() ?? "no data";
        // msg = stringToBase64Url.decode(msg);
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
        msg += stringToBase64Url.decode(messageData.payload?.parts?.first.body?.data ?? "no data");
        msg += "\n\n\n\n\nNew mail \n\n\n\n";
      }
    });
  }
}