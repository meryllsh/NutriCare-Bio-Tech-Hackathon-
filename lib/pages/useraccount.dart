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
  bool isLoading = true;
  late String status;

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
      isLoading = false;
      if (age! > 60) {
        status = 'Elderly';
      } else if (age! > 18) {
        status = 'Adult';
      } else {
        status = 'Child';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset('assets/nutricaretitle.png'),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Authentication().signOut();
            Navigator.of(context).pushReplacementNamed('/Login');
          },
          child: Icon(Icons.logout, color: Colors.white),
          backgroundColor: Color(0xFF2abca4),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2abca4),
                            width: 10.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl!),
                          radius: 70.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Username:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF2abca4),
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF2abca4),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text('$username',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10.0),
                        Text('Age:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF2abca4),
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF2abca4),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text('$age',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 18),
                        Text('Status:',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF2abca4),
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF2abca4),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text('$status',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 0.0), // Adjust these values as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF2abca4),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              '$email',
                              style: TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}