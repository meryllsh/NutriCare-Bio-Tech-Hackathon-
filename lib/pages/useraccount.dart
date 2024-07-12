import 'package:flutter/material.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/models/usermodel.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}



class _UserAccountState extends State<UserAccount> {
  String? username;
  String? email;
  int? age;
  String? photoUrl;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    UserModel userDetails = await Authentication().getUserDetails();
    String freshPhotoUrl = userDetails.photoUrl;
    setState(() {
      username = userDetails.username;
      email = userDetails.email;
      age = userDetails.age;
      photoUrl = freshPhotoUrl; // Updated to use the fresh URL
      print('Photo URL: $photoUrl');
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading?CircularProgressIndicator():
           CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl!),
            ),
              Text('$username\n$email\n$age\n$photoUrl'),
              ElevatedButton(
                onPressed: () async {
                  await Authentication().signOut();
                  Navigator.pushReplacementNamed(context, '/Login');
                },
                child: Text('Logout'),
              ),
            ],
        ),
      ),
    );
  }
}