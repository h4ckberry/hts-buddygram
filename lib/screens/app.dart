import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            // brightness: Brightness.light,
          ),
        ),
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
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/background/home_back.png"), fit: BoxFit.fill)),
          ),
          homescreen(),
        ],
      ),
    );
  }
}

Widget homescreen() {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Image(
            height: 100,
            image: AssetImage('assets/images/logos/logo_white.png'),
            fit: BoxFit.contain,
          ),
          Padding(padding: EdgeInsets.all(20.0)),
          Text(
            '''
            Buddygramへようこそ。
            あなたと動物の相性を診断します。

            バディースコア（相性）が高い動物となら、
            どんな困難もきっと乗り切れるはずです。

            さあ、早速診断を始めましょう！
            ''',
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.all(10.0)),
          Image(
            height: 100,
            image: AssetImage('assets/images/others/line.png'),
            fit: BoxFit.contain,
          ),
          Padding(padding: EdgeInsets.all(10.0)),
          GestureDetector(
            onTap: () {
              // Navigator.pop(context);
            },
            child: Image(
              width: 200,
              image: AssetImage('assets/images/buttons/image_pick.png'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
  );
}
