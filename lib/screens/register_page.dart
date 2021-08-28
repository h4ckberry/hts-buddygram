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
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/background/login_back.png"), fit: BoxFit.fill)),
          ),
          registerscreen(),
        ],
      ),
    );
  }

  Widget registerscreen() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage('assets/images/logos/logo_color.png'),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                Image(
                  width: 100,
                  image: AssetImage('assets/images/others/signin.png'),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                // child: Column(children: <Widget>[
                //   CupertinoFormSection.insetGrouped(
                //     header: const Text('SECTION 1'),
                //     children: <Widget>[
                const Text(
                  'ユーザーネーム',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                CupertinoTextFormFieldRow(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  placeholder: 'username',
                  controller: nameInputController,
                  validator: (value) {
                    if (value != null && value.length < 3) {
                      return "名前は3文字以上で入力してください";
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                const Text(
                  'メールアドレス',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                CupertinoTextFormFieldRow(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  placeholder: 'mial.@spajam.jp',
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
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  placeholder: 'password',
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                //   ],
                // ),
                Padding(padding: EdgeInsets.all(20.0)),
                GestureDetector(
                  onTap: () {
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
                  child: Image(
                    width: 200,
                    image: AssetImage('assets/images/buttons/btn_regist.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20.0)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image(
                    width: 200,
                    image: AssetImage('assets/images/buttons/btn_registed.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ]),
            ),
          )),
    );
  }
}
