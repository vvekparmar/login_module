import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class ForgotPassword extends StatefulWidget {
  String email;
  ForgotPassword(this.email);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState(this.email);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String newPassword,confirmPassword,email;
  _ForgotPasswordState(this.email);

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
                    child: Text("Forgot Password",
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
                        prefixIcon: Icon(Icons.lock),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "New Password",
                      ),
                      onChanged: (value) {
                        setState(() {
                            newPassword = value.trim();
                        });
                      },
                    ),
                    SizedBox(height:20),
                    TextField(
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        hintText: "Confirm Password",
                      ),
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.lightBlueAccent,
                        textColor: Colors.white,
                        child: Text("Set Password",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                        onPressed: () async {
                          if(newPassword == confirmPassword)
                          {
                              List data;
                              CollectionReference collectionReference = Firestore.instance.collection('User_Data');
                              QuerySnapshot querySnapshot = await collectionReference.getDocuments();
                              collectionReference.snapshots().listen((snapshot) {
                                data = snapshot.documents;
                                for(int i=0;i<data.length;i++)
                                {
                                  if(email == data[i]['email'])
                                  {
                                    querySnapshot.documents[i].reference.updateData({"email":email,
                                      "contactNo":data[i]['contactNo'],"username":data[i]['username'],"password":confirmPassword});
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
                                  }
                                }
                              });
                          }
                          else {
                            Fluttertoast.showToast(
                              msg: "Confirm Password not matched with New Password.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM_RIGHT,
                            );
                          }
                        },
                      ),
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