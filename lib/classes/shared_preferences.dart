import 'package:shared_preferences/shared_preferences.dart';

class SharedActions{
  SharedPreferences preferences;

  init() async{
    preferences = await SharedPreferences.getInstance(); 
  }

  setUserAuth(user, pass, uid) async{
    await init();
    preferences.setString('user', user);
    preferences.setString('pass', pass);
    preferences.setString('uid', uid);

  }

  clear() async{
    await init();
    preferences.clear();
  }

}