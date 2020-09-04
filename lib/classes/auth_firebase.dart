import 'package:firebase_auth/firebase_auth.dart';

import 'package:app_grupal/models/authentication_model.dart';

class AuthFirebase{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthObject resp = new AuthObject();

  Future<AuthObject> signIn(String user, String pass) async{
    print("#### signIn");
    try{
      UserCredential result = await firebaseAuth
        .signInWithEmailAndPassword(email: user, password: pass)
        .timeout(Duration(milliseconds: 10000));
      resp = AuthObject(email: result.user.email, uid: result.user.uid, result: true, mensaje: 'Sesión iniciada correctamente');
      print(resp);
    }catch(e){
      print(e);
      resp = AuthObject(email: null, uid: null, result: false, mensaje: '$e');
    }

    return resp; 
  }

  Future<String> currentUser() async{
    if(firebaseAuth.currentUser != null)
      return firebaseAuth.currentUser.uid;
    return null;
  }

  Future<void> signOut(){
    return firebaseAuth.signOut();
  }

  Future<bool> changePass(String currentPass, String user, String newPass) async{
    bool result = false;
    try{
      await firebaseAuth.currentUser.updatePassword(newPass).timeout(Duration(milliseconds: 10000));
      result = true;
    }catch(e){
      print(e);
    }
    return result;
  }


}