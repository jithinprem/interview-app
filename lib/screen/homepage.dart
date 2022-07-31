import 'package:flutter/material.dart';
import 'package:interview/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getQuestion(index) {
    return (computerNetwork[index * 2 - 1]);
  }

  var ind = 0;
  var _vis = false;
  var txtbut = 'SHOW';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(primaryColor: Colors.lightGreen),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'PrepareNow',
              style: TextStyle(
                fontFamily: 'HomemadeApple',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.4,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(4.0, 4.0),
                    blurRadius: 6.0,
                    color: Colors.black54
                  ),
                ],
              ),
            ),
            surfaceTintColor: Colors.lime,
            shadowColor: Colors.lime,
            leading: Icon(Icons.menu),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        computerNetwork[ind * 2],
                        style: TextStyle(
                            color: Colors.lime, fontFamily: 'Rubik'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _vis,
                        child: Text(computerNetwork[ind * 2 + 1]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if(txtbut == 'SHOW'){
                              _vis = true;
                              txtbut = 'HIDE';
                            }
                            else if(txtbut == 'HIDE'){
                              _vis = false;
                              txtbut = 'SHOW';
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffF5F0BB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            txtbut,
                            style: TextStyle(color: Colors.black54),
                          )),
                          width: double.infinity,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            var p = computerNetwork.length-1;
                            ind = (ind +1)%p;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffF5F0BB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                                'NEXT QUESTION',
                                style: TextStyle(color: Colors.black54, fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                              )),
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
