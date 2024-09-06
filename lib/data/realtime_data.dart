import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserStatusService {
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
  final DatabaseReference _userStatusRef;
  final DatabaseReference _connectedRef;
  final String _userId;

  UserStatusService(String userId)
      : _userStatusRef = FirebaseDatabase.instance.ref('onlinePlayers'),
        _connectedRef = FirebaseDatabase.instance.ref('.info/connected'),
        _userId = userId;

  void trackUserStatus() async {
    _connectedRef.onValue.listen((event) async {
      final bool isConnected = event.snapshot.value as bool? ?? false;
      final DocumentReference docRef = collectionReference.doc(_userId);

      debugPrint('Connection state: $isConnected'); // Debugging print

      if (isConnected) {
        final DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final String? name = await docSnapshot.get('name') as String?;
          final String? profilePhoto = await docSnapshot.get('photoURL') as String?;
          // User is online, update their status
          _userStatusRef.child(_userId).update({
            'status': 'online',
            'lastChanged': DateTime.now().toString(),
            'name': name,
            'photoURL': profilePhoto
          });
        }

        // Setup onDisconnect to set status as offline
        _userStatusRef.child(_userId).onDisconnect().update({
          'status': 'offline',
          'lastChanged': DateTime.now().toString(),
        }).catchError((error) {
          debugPrint('Error setting onDisconnect: $error');
        });
      } else {
        debugPrint('User is offline');
      }
    }).onError((error) {
      debugPrint('Connection state listener error: $error');
    });
  }

  void setOffline(){
    // Setup onDisconnect to set status as offline
        _userStatusRef.child(_userId).update({
          'status': 'offline',
          'lastChanged': DateTime.now().toString(),
        }).catchError((error) {
          debugPrint('Error setting onDisconnect: $error');
        });
  }
}
