import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController{
  final _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  login() async {
    googleAccount.value = await _googleSignIn.signIn();
  }
}