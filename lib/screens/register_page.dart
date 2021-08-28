import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  late TextEditingController nameInputController;
  late TextEditingController emailInputController;
  late TextEditingController pwdInputController;
  // late FromFirestore Firestore.instance;

  @override
  initState() {
    nameInputController = new TextEditingController();
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
        // navigationBar: const CupertinoNavigationBar(
        //   middle: Text('Login App'),
        // ),
        child: registerscreen());
  }

  Widget registerscreen() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(children: <Widget>[
                CupertinoFormSection.insetGrouped(
                  header: const Text('SECTION 1'),
                  children: <Widget>[
                    CupertinoTextFormFieldRow(
                      prefix: const Text('UserName: '),
                      placeholder: 'Lebron',
                      controller: nameInputController,
                      validator: (value) {
                        if (value != null && value.length < 3) {
                          return "名前は3文字以上で入力してください";
                        }
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Email: '),
                      placeholder: 'hogehoge.fugaguga@gmail.com',
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: const Text('Password: '),
                      placeholder: '********',
                      controller: pwdInputController,
                      obscureText: true,
                      validator: pwdValidator,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                CupertinoButton(
                  child: Text(
                    "アカウント作成",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_registerFormKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: emailInputController.text,
                            password: pwdInputController.text,
                          )
                          .then((currentUser) => FirebaseFirestore.instance
                              .collection("users")
                              .doc(currentUser.user!.uid)
                              .set({
                                "uid": currentUser.user!.uid,
                                "name": nameInputController.text,
                                "email": emailInputController.text,
                              })
                              .then((result) => {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                // uid: currentUser.user!.uid,
                                                )),
                                        (_) => false),
                                    nameInputController.clear(),
                                    emailInputController.clear(),
                                    pwdInputController.clear(),
                                  })
                              .catchError((err) => print(err)))
                          .catchError((err) => print(err));
                    }
                  },
                ),
                CupertinoButton(
                  child: Text(
                    "ログイン",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]),
            ),
          )),
    );
  }
}
