import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String? emailValidator(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value != null && !regex.hasMatch(value)) {
      return '正しいEmailのフォーマットで入力してください';
    } else {
      return null;
    }
  }

  String? pwdValidator(String? value) {
    if (value != null && value.length < 8) {
      return 'パスワードは8文字以上で入力してください';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/background/login_back.png"), fit: BoxFit.fill)),
          ),
          loginscreen(),
        ],
      ),
    );
    // child: loginscreen());
  }

  Widget loginscreen() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(40.0),
                child: Image(
                  width: 300,
                  image: AssetImage('assets/images/logos/logo_color.png'),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0)),
              const Text(
                'メールアドレス',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              CupertinoTextFormFieldRow(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                placeholder: 'mial.@spajam.jp',
                style: TextStyle(color: Colors.grey.shade400),
                controller: emailInputController,
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              const Text(
                'パスワード',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              CupertinoTextFormFieldRow(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                placeholder: 'password',
                style: TextStyle(color: Colors.grey.shade400),
                controller: pwdInputController,
                obscureText: true,
                validator: pwdValidator,
              ),
              // ],
              // ),
              Padding(padding: EdgeInsets.all(20.0)),
              GestureDetector(
                onTap: () {
                  if (_loginFormKey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: emailInputController.text,
                          password: pwdInputController.text,
                        )
                        .then((currentUser) => FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUser.user!.uid)
                            .get()
                            .then((DocumentSnapshot result) => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()))})
                            .catchError((err) => print(err)))
                        .catchError((err) => print(err));
                  }
                },
                child: Image(
                  width: 250,
                  image: AssetImage('assets/images/buttons/btn_login.png'),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(padding: EdgeInsets.all(20.0)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/register");
                },
                child: Image(
                  width: 250,
                  image: AssetImage('assets/images/buttons/btn_regist_start.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
