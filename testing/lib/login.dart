import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testing/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget{
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(
        child: Obx((){
          if(controller.googleAccount.value == null){
            return buildLoginButton();
          }
          else{
            return buildProfileView();
          }
        }),
      ),
    );
  }

  Column buildProfileView() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: Image.network(controller.googleAccount.value?.photoUrl ?? '').image,
            radius: 100,
          ),
          Text(
            controller.googleAccount.value?.displayName ?? '',
            style: Get.textTheme.headline3,
          ),
          Text(
            controller.googleAccount.value?.email ?? '',
            style: Get.textTheme.bodyText1,
          ),
        ],
      );
  }

  FloatingActionButton buildLoginButton() {
    return FloatingActionButton.extended(
          onPressed: () {
            controller.login();
          },
          icon: Image.asset(
            'assets/images/google_logo.png',
            height: 32,
            width: 32,
          ),
          label: Text("Sign in with Google"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
      );
  }
}