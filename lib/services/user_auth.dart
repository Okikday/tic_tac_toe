// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/firebase_data.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/views/authentication/verify_email.dart';

class UserAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  final GoogleSignIn _googleAuth = GoogleSignIn();
  String? message;
  final FirebaseData _firebaseData = FirebaseData();
  UserCredential? _userCredential;


  Future<String?> createUserAccount(String email, String password) async{
    try {
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email already in use!";
      } else if (e.code == 'invalid-email') {
        return "Invalid email address!";
      } else if (e.code == 'weak-password') {
        return "The password provided is too weak!";
      } else {
        return "An unknown error occurred!";
      }
    }

  }

  Future<String?> signUpWithEmailAndPassword(BuildContext context, String email, String password, String nameText) async {
  message = await createUserAccount(email, password);
  await _firebaseAuth.currentUser!.sendEmailVerification();
  if (message == null) {
    String uid = _userCredential!.user!.uid;
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyEmail(
            name: nameText,
            email: email,
            password: password,
            uid: uid,
          ),
        ),
      );
    }
    return null;
  } else {
    return message;
  }
}




  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      _userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return [_userCredential!.user!.uid]; // Sign-in successful, no error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "User not found!";
      } else if (e.code == 'wrong-password') {
        return "Wrong password!";
      }else{
        return "Error logging in...";
      }
      
    }
  }

  Future<String?> signInWithGoogle(BuildContext context) async {
  try {

    // Triggering the authentication flow
    final GoogleSignInAccount? googleUser = await _googleAuth.signIn();
    if (googleUser == null) {
      return "Google Sign-In was canceled by the user.";
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    // Return the user's UID upon successful sign-in
    final String name = userCredential.user!.displayName ?? "Anonymous";
    final String uid = userCredential.user!.uid;
    final String email = userCredential.user!.email ?? "anonymous@gmail.com";
    final String photoURL = userCredential.user!.photoURL ?? "not-set";

    String? outcomeCreateUser = await _firebaseData.createUserData(uid, name, "", email, "Google", photoURL: photoURL);
    if(outcomeCreateUser == null){
      if(context.mounted) Provider.of<DeviceProvider>(context, listen: false).saveUserDetails(name, email, uid, photoURL);

      return null;
    }else{
      return outcomeCreateUser;
    }

    
    
  } on FirebaseAuthException catch (e) {
    if (e.code == 'account-exists-with-different-credential') {
      return "Account already exists with a different credential!";
    } else if (e.code == 'invalid-credential') {
      return "Invalid credentials!";
    } else {
      return "An unknown error occurred!";
    }
  } catch (e) {
    return "An error occurred during Google Sign-In: $e";
  }
}

}
