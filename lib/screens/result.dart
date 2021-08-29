import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:google_fonts/google_fonts.dart';

// final appRoutes = {
//   '/talk': (BuildContext context) => TalkPage(),
// };

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _result = ModalRoute.of(context)!.settings.arguments as double;
    final _sync_rate = ((_result * 100) * 10).floor() / 10;
    print("########## ${_sync_rate} ##########");
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(image: new DecorationImage(image: new AssetImage("assets/images/background/default_back.png"), fit: BoxFit.fill)),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(20.0)),
                  Image(
                    height: 100,
                    image: AssetImage('assets/images/logos/logo_white.png'),
                    fit: BoxFit.contain,
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Image(
                    width: 200,
                    image: AssetImage('assets/images/others/result.png'),
                    fit: BoxFit.contain,
                  ),
                  Padding(padding: EdgeInsets.all(5.0)),
                  Text("あなたとのバディスコア（相性）は...", style: TextStyle(fontSize: 16)),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Center(
                        child: Container(
                          height: 250,
                          padding: EdgeInsets.all(30.0),
                          child: new RotatedBox(
                            quarterTurns: -1,
                            child: PieChart(
                              colorList: [Color.fromRGBO(251, 255, 0, 1), Color.fromRGBO(0, 208, 230, 1)],
                              animationDuration: Duration(milliseconds: 800),
                              dataMap: {
                                "result": _sync_rate,
                                "none": (100 - _sync_rate),
                              },
                              chartType: ChartType.ring,
                              ringStrokeWidth: 60,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                showLegends: false,
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${_sync_rate}%",
                          style: TextStyle(fontSize: 38, color: Color.fromRGBO(251, 255, 0, 1)),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Image(
                    width: 300,
                    image: AssetImage('assets/images/others/comment.png'),
                    fit: BoxFit.contain,
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image(
                      width: 250,
                      image: AssetImage('assets/images/buttons/btn_re.png'),
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

// Widget resultscreen() {
//   return 
// }
