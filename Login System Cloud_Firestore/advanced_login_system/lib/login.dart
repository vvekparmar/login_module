import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup.dart';
import 'home.dart';
import 'getEmail.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email,password,username;

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
    return "Login Successfully";
  }

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
                    padding: EdgeInsets.only(left:30,top:55),
                    child: Text("LOGIN",
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
                    SizedBox(height: 15),
                    GestureDetector(
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GetEmail()));
                      },
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Container(
                          height: 57,
                          width: MediaQuery.of(context).size.width * 0.37,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            child: Text("Login",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                            onPressed:() async{
                                List data;
                                CollectionReference collectionReference = Firestore.instance.collection('User_Data');
                                collectionReference.snapshots().listen((snapshot) {
                                  data = snapshot.documents;
                                  for(int i=0;i<data.length;i++)
                                  {
                                    if(data[i]['email'] == email)
                                    {
                                      if(data[i]['password'] == password)
                                      {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                        break;
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(
                                          msg: "Your provided password is wrong",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM_RIGHT,
                                        );
                                      }
                                    }
                                  }
                                });
                            },
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01),
                        FlatButton(
                          child:CircleAvatar(backgroundImage:AssetImage('assets/images/google.jpg'),radius:30),
                          onPressed: () => googleSignIn().whenComplete(() => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))
                          }),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.01),
                        CircleAvatar(backgroundImage:AssetImage('assets/images/facebook.jpg'),radius:30),
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      child: Text(
                        "Don't have an Account? Create one",
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: Colors.blueAccent, fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
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