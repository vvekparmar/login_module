import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'forgotPassword.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class AuthUser extends StatefulWidget {
  String email;
  int currentOTP;
  AuthUser(this.email,this.currentOTP);
  @override
  _AuthUserState createState() => _AuthUserState(this.email,this.currentOTP);
}

class _AuthUserState extends State<AuthUser> {
  String email,otp;
  int currentOTP;
  _AuthUserState(this.email,this.currentOTP);
  generateOTP() async
  {
    Random random = new Random();
    currentOTP = random.nextInt(500000) + 200000;

    String username = 'prestigiousman1807@gmail.com';
    String password = 'dh@rmesh18';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      ..subject = 'Reset Password'
      ..text = 'Your Verification Code is $currentOTP';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString());
    }
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
                    padding: EdgeInsets.only(left: 30, top: 55),
                    child: Text("Verify Account",
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
                        hintText: "OTP",
                      ),
                      onChanged: (value) {
                        setState(() {
                          otp = value.trim();
                        });
                      },
                    ),
                    SizedBox(height: 40),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.lightBlueAccent,
                        textColor: Colors.white,
                        child: Text("Verify",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        onPressed: () {
                          if (currentOTP == int.parse(otp)) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPassword(email)));
                          }
                          else
                            {
                              Fluttertoast.showToast(
                                msg: "Your provided OTP is incorrect.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM_RIGHT,
                              );
                            }
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                        child: Text(
                          "Get Another OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.lightBlueAccent, fontSize: 18),
                        ),
                        onTap: () => generateOTP())
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
