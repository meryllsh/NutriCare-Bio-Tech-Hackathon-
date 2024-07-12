import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String username;
  final int age;
  final String photoUrl;

  UserModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.age,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'age': age,
        'photoUrl': photoUrl,
        'uid': uid,
      };


  static UserModel SnapData(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      age: snapshot['age'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
