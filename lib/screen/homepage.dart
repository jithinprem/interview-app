import 'package:flutter/material.dart';
import 'package:interview/actions/a_database.dart';
import 'package:interview/actions/add_mannual_data.dart';
import 'package:interview/actions/delete_entry.dart';
import 'package:interview/actions/get_home_question.dart';
import 'package:interview/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:interview/actions/get_no_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  getval() async{
    GetQue().get_home_question('cn').then((List l){
      allque = l;
    });
    setState((){
      presentque = allque[0]['question'];
      presentans = allque[0]['answer'];
    });
    return allque;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_total_items().then((ret_count){
      setState((){
        totalcount = ret_count;
        print('the total item changed to $totalcount');
      });
    });
    print('the total items is set to $totalcount');
    getval();

  }

  var ind = 0;
  var _vis = false;
  var txtbut = 'SHOW';
  var buttonfield = false;
  var ansfield = false;
  var quefield = false;
  String currsubject = 'cn';
  var select_que =1;   // later do it by reinforcement learning
  String presentque = 'welcome to preparenow';
  String presentans = 'learn for your interviews, viva\'s with us..\nEnter next to view your questions';
  List allque = [];

  TextEditingController que = TextEditingController();
  TextEditingController ans = TextEditingController();

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
            leading: IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                // delete
                print('this question is going to be deleted');
                print(allque[select_que]['id']);
                print(allque[select_que]['question']);
                int deleteque = allque[select_que]['id'];
                setState((){
                  print('setstate called');
                  select_que = (select_que + 1)%(totalcount-2);
                  presentque = allque[select_que]['question'];
                  presentans = allque[select_que]['answer'];
                });
                DeleteEntry().delete_using_id(deleteque);
                getval();
              },
            ),
            actions: [
              IconButton(onPressed: (){
                //set all the items to invisible and show text field
                setState((){
                  ansfield = !ansfield;
                  quefield= !quefield;
                  buttonfield = !buttonfield;
                });
              }, icon: Icon(Icons.add)),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      Visibility(
                        visible: quefield,
                          child: TextField(
                            controller: que,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              hintText: 'new question',
                            ),
                          ),
                      ),
                      Visibility(
                        visible: ansfield,
                        child: TextField(
                          controller: ans,
                          minLines: 27,
                          maxLines: 28,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            hintText: 'solution',
                          ),
                        ),
                      ),
                      Visibility(
                          visible: buttonfield,
                          child: TextButton(
                            onPressed: () async{
                              String q1 = que.text;
                              String a1 = ans.text;
                              computerNetwork.add(computerNetwork.length.toString()+ ') ' +q1);
                              computerNetwork.add(a1);
                              // add to database call a function
                              print('adding to database');
                              AddtoDataBase().addData(q1, a1, currsubject).then((List l) async{
                                await getval();
                              });

                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 50),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xffF5F0BB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              child: const Center(
                                  child: Text(
                                    'SUBMIT',
                                    style: TextStyle(color: Colors.black54, fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                      ),
                      Text(
                        //currque[0]['question'],
                        presentque,
                        style: const TextStyle(
                            color: Colors.lime, fontFamily: 'Rubik'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _vis,
                        child: Text(presentans),
                      ),
                      const SizedBox(
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
                          width: double.infinity,
                          child: Center(
                              child: Text(
                            txtbut,
                            style: TextStyle(color: Colors.black54),
                          )),
                        ),
                      ),
                      TextButton(
                        onPressed: () async{
                          setState((){
                            select_que = (select_que +1)%(allque.length+1);
                            presentque = allque[select_que]['question'];
                            presentans = allque[select_que]['answer'];
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xffF5F0BB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: const Center(
                              child: Text(
                                'NEXT',
                                style: TextStyle(color: Colors.black54, fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),

                      Visibility(
                        visible: false,
                        child: TextButton(
                          onPressed: () async{
                            AddMannualData().AddData();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xffF5F0BB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'Fetch question',
                                  style: TextStyle(color: Colors.black54, fontFamily: 'Rubik', fontWeight: FontWeight.bold),
                                )),
                            width: double.infinity,
                          ),
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
