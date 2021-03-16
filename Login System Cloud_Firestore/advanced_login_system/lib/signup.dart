import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email,password,username,contact;

  Future<String> googleSignIn() async{
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;

    assert(user.email != null);
    assert(user.displayName != null);

    setState(() {
      username = user.displayName;
      email = user.email;
    });

    final User currentUser = await _firebaseAuth.currentUser;
    assert(currentUser.uid == user.uid);
    return "SignUP Successfully";
  }

  int flag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: ClipPath(
                      clipper: SideClipper(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.lightBlueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topLeft),
                        ),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: OvalClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5, 5),
                              blurRadius: 1.0,
                              spreadRadius: 1.0)
                        ],
                        gradient: LinearGradient(colors: [
                          Colors.lightBlueAccent,
                          Colors.lightBlueAccent,
                          Colors.blue,
                          Colors.blue
                        ], begin: Alignment.bottomLeft, end: Alignment.topLeft),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left:25,top:55),
                    child: Text("SIGN UP",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "Username",
                      ),
                      onChanged: (value) {
                        setState(() {
                          username = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "Email Address",
                      ),
                      onChanged: (value) {
                        setState(() {
                          email = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "Contact Number",
                      ),
                      onChanged: (value) {
                        setState(() {
                          contact = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "Password",
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Container(
                          height: 57,
                          width: MediaQuery.of(context).size.width*0.37,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            child: Text("SIGN UP",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                            onPressed: () async {
                              List getInfo;
                              Map<String,dynamic> data = {
                                  "username":username,
                                  "email":email,
                                  "contactNo":contact,
                                  "password":password
                                };
                                CollectionReference collectionReference = Firestore.instance.collection('User_Data');
                                collectionReference.snapshots().listen((snapshot) {
                                getInfo = snapshot.documents;
                                for(int i=0;i<getInfo.length;i++)
                                {
                                  if(email == getInfo[i]['email'])
                                    {
                                      flag == 1;
                                      break;
                                    }
                                }
                              });
                                if(flag == 0)
                                  {
                                    collectionReference.add(data)
                                        .then((_){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                    });
                                  }
                                else
                                  {
                                    Fluttertoast.showToast(
                                      msg: "Your provided Email Address already existed.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM_RIGHT,
                                    );
                                  }
                            },
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                        FlatButton(
                          child:CircleAvatar(backgroundImage:AssetImage('assets/images/google.jpg'),radius:30),
                          onPressed: () => googleSignIn().whenComplete(() => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))
                          }),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                        CircleAvatar(backgroundImage:AssetImage('assets/images/facebook.jpg'),radius:30),
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      child: Text(
                        "Account Already Existed! Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SideClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 2 / 5;
    final filledRectangle =
    Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        0, size.height - roundingHeight * 2, size.width + 5, size.height);

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, 3.14, -3.14, true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    final roundingHeight = size.height * 1;
    final roundingRectangle = Rect.fromLTRB(
        -100, size.height - roundingHeight * 2, size.width, size.height);
    path.arcTo(roundingRectangle, 3.14, -3.14, true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}