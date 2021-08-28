import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'result.dart';

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
          '/result': (BuildContext context) => ResultPage(),
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(mode: FaceDetectorMode.accurate, enableLandmarks: true, enableClassification: true),
  );
  final imageLabeler = GoogleMlKit.vision.imageLabeler();
  final _picker = ImagePicker();

  void _getImageAndFindFace(BuildContext context, ImageSource imageSource) async {
    final PickedFile? pickedImage = await _picker.getImage(source: imageSource);
    final File imageFile = File(pickedImage!.path);

    final InputImage visionImage = InputImage.fromFile(imageFile);
    List<Face> faces = await _faceDetector.processImage(visionImage);
    List<ImageLabel> labels = await imageLabeler.processImage(visionImage);

    bool _isDog = false;
    for (ImageLabel label in labels) {
      if (label.label == "Dog") {
        _isDog = true;
        print("########## 犬いたよ ########");
        break;
      }
    }

    print("########## 処理終わったよ ########");

    if (faces.length > 0) {
      // String imagePath = "/images/" + Uuid().v1() + basename(pickedImage.path);
      // Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      // final TaskSnapshot storedImage = await ref.putFile(imageFile);

      // final String downloadUrl = await storedImage.ref.getDownloadURL();
      Face largestFace = findLargestFace(faces);

      // FirebaseFirestore.instance
      //     .collection("smiles")
      //     .add({"name": _name, "smile_prob": largestFace.smilingProbability, "image_url": downloadUrl, "date": Timestamp.now(), "label": labels[0], "label2": labels[1], "label3": labels[2]});

      Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
  }

  Face findLargestFace(List<Face> faces) {
    Face largestFace = faces[0];
    for (Face face in faces) {
      if (face.boundingBox.height + face.boundingBox.width > largestFace.boundingBox.height + largestFace.boundingBox.width) {
        largestFace = face;
      }
    }
    return largestFace;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage("assets/images/background/home_back.png"), fit: BoxFit.fill),
            ),
          ),
          // homescreen(),
          Center(
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
                      _getImageAndFindFace(context, ImageSource.gallery);
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
          ),
        ],
      ),
    );
  }
}

// Widget homescreen() {
//   return Center(
//     child: Container(
//       padding: const EdgeInsets.all(40.0),
//       child: Column(
//         children: [
//           Image(
//             height: 100,
//             image: AssetImage('assets/images/logos/logo_white.png'),
//             fit: BoxFit.contain,
//           ),
//           Padding(padding: EdgeInsets.all(20.0)),
//           Text(
//             '''
//             Buddygramへようこそ。
//             あなたと動物の相性を診断します。

//             バディースコア（相性）が高い動物となら、
//             どんな困難もきっと乗り切れるはずです。

//             さあ、早速診断を始めましょう！
//             ''',
//             textAlign: TextAlign.center,
//           ),
//           Padding(padding: EdgeInsets.all(10.0)),
//           Image(
//             height: 100,
//             image: AssetImage('assets/images/others/line.png'),
//             fit: BoxFit.contain,
//           ),
//           Padding(padding: EdgeInsets.all(10.0)),
//           GestureDetector(
//             onTap: () {
//               getImageFromCamera();
//             },
//             child: Image(
//               width: 200,
//               image: AssetImage('assets/images/buttons/image_pick.png'),
//               fit: BoxFit.contain,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
