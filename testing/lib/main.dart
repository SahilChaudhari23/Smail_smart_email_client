import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:testing/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      title: "Sign In",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}