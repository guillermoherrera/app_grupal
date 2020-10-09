import 'package:firebase_auth/firebase_auth.dart';

import 'package:app_grupal/models/authentication_model.dart';

class AuthFirebase{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  AuthObject resp = new AuthObject();

  Future<AuthObject> signIn(String user, String pass) async{
    print("#### signIn");
    try{
      UserCredential result = await firebaseAuth
        .signInWithEmailAndPassword(email: '$user@confia.com', password: pass)
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

  Future<bool> changePass(String user, String pass, String newPass) async{
    bool result = false;
    try{
      await firebaseAuth
        .signInWithEmailAndPassword(email: '$user@confia.com', password: pass)
        .timeout(Duration(milliseconds: 10000));
      await firebaseAuth.currentUser.updatePassword(newPass).timeout(Duration(milliseconds: 10000));
      result = true;
    }catch(e){
      print('Error changePass $e');
    }
    return result;
  }


}