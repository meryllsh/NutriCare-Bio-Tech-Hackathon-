import 'dart:typed_data';
import 'package:nutricare/firebasestuff/storage.dart';
import 'package:nutricare/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  // username=(snap.data() as Map<String,dynamic>)['username'] possible to use such a method for followers email pass etc... but it takes time so a more efficient method was used
  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(
        currentUser.uid).get();

    return UserModel.SnapData(snap);
  }



  // sign up the user

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required int age,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          age >0 ) {
        // register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePicture', file);
        // add user to our database
        // note model is user from the user.dart file but it has been renamed to the model on the import line as there is already an existing User type from firebase auth
        // Create a UserModel instance with the user data
        UserModel user = UserModel(
          email: email,
          username: username,
          age: age,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
          user.toJson(),
        );

        //
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//sign out
Future<void> signOut()async {
   await _auth.signOut();
}


}


