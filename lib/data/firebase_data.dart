import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseData {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  createUserData(String uid, String name, String password, String email, String accountType, {String? photoURL}) async {
    try {
      await _collectionReference.doc(uid).set({
        'name': name,
        'id': uid,
        'password': password,
        'email': email,
        'accountType' : accountType,
        'photoURL' : photoURL ?? 'not-set',
      });
      
      return null;
    } catch (e) {
      return "Unable to add user!";
    }
  }

  Future<dynamic> getUserData(String userId) async {
    try {

      // Reference the user's document in Firestore
      DocumentReference userDocReference = _collectionReference.doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocReference.get();

      if (userDocSnapshot.exists) {
        // Extract the user data from the document snapshot
        Map<String, dynamic>? userData = userDocSnapshot.data() as Map<String, dynamic>?;


        if (userData == null || userData.isEmpty) {
          return "Unable to fetch user data";
        }
        return userData;
      } else {
        return "User document does not exist!";
      }
    } catch (e) {
      return "An error occurred while fetching user data";
    }
  }
}
