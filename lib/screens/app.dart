import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'register_page.dart';

class BaseApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  bool _isLogin = false;

  @override
  initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _isLogin = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.light),
        // home: HomePage(),
        home: _isLogin ? HomePage() : LoginPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/login': (BuildContext context) => LoginPage(),
          // '/talk': (BuildContext context) => TalkPage(),
        });
  }
}

// final appRoutes = {
//   '/talk': (BuildContext context) => TalkPage(),
// };

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Sample Code'),
        ),
        child: Container(
          child: Center(
            child: Text("home page"),
          ),
        ));
  }
}
