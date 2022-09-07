import 'package:flutter/material.dart';
import 'package:interview/actions/a_database.dart';
import 'package:interview/actions/add_mannual_data.dart';
import 'package:interview/actions/delete_entry.dart';
import 'package:interview/actions/get_home_question.dart';
import 'package:interview/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:interview/actions/get_no_items.dart';
import 'dart:math';
import '../stored_constant/stored_constant.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getval() async {
    GetQue().get_home_question(circle_avatars[_value]).then((List l) {
      allque = l;
      print('this is the obtained list of que');
      print(l);
    });
    setState(() {
      // presentque = allque[0]['question'];
      // presentans = allque[0]['answer'];
      presentque = 'Welcome, it\'s time to learn';
      presentans = 'Click Next to continue';
    });
    return allque;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_total_items().then((ret_count) {
      setState(() {
        totalcount = ret_count;
        print('the total item changed to $totalcount');
      });
      return totalcount;
    });
    print('the total items is set to $totalcount');
    getval();
  }

  int _value = 0;
  int queno =1;
  List<String> list_subjects = ['CompNet', 'Pyth', 'Java', 'DBMS', 'OpSys', 'DataSt', 'Cprog'];
  List<String> circle_avatars = ['cn', 'py', 'j', 'db', 'os', 'ds', 'cp'];
  var ind = 0;
  var _vis = false;
  var txtbut = 'SHOW';
  var buttonfield = false;
  var ansfield = false;
  var quefield = false;
  String currsubject = 'cn';
  var select_que = 1; // later do it by reinforcement learning
  String presentque = 'welcome to preparenow';
  String presentans =
      'learn for your interviews, viva\'s with us..\nEnter next to view your questions';
  String presentid = '';
  String presentpt = '';
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
                      color: Colors.black54),
                ],
              ),
            ),
            surfaceTintColor: Colors.lime,
            shadowColor: Colors.lime,
            leading: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // delete
                print('this question is going to be deleted');
                print(allque[select_que]['id']);
                print(allque[select_que]['question']);
                int deleteque = allque[select_que]['id'];
                setState(() {
                  print('setstate called');
                  select_que = (select_que + 1) % (totalcount) -1;
                  print('the selected question is $select_que');
                  presentque = allque[select_que]['question'];
                  presentans = allque[select_que]['answer'];
                });
                DeleteEntry().delete_using_id(deleteque);
                getval();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //set all the items to invisible and show text field
                    setState(() {
                      ansfield = !ansfield;
                      quefield = !quefield;
                      buttonfield = !buttonfield;
                    });
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: List<Widget>.generate(
                    7,
                    (int index) {
                      return ChoiceChip(
                        avatar: CircleAvatar(
                          child: Text(circle_avatars[index], style: TextStyle(fontSize: 9),),
                        ),
                        selectedColor: Colors.lime[800],
                        label: Text(list_subjects[index], style: TextStyle(color: Colors.black87),),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : 0;
                            currsubject = circle_avatars[_value];
                            print('the value selected is : $currsubject');
                            getval();
                            // set the subject and call addData again
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
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
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'solution',
                          ),
                        ),
                      ),
                      Visibility(
                        visible: buttonfield,
                        child: TextButton(
                          onPressed: () async {
                            String q1 = 'Q) ${que.text}';
                            String a1 = 'A) ${ans.text}';
                            computerNetwork.add(
                                computerNetwork.length.toString() + ') ' + q1);
                            computerNetwork.add(a1);
                            // add to database call a function
                            print('adding to database');
                            AddtoDataBase()
                                .addData(q1, a1, currsubject)
                                .then((List l) async {
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
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.bold
                              ),
                            )),
                          ),
                        ),
                      ),
                      Text(
                        //currque[0]['question'],
                        presentque ,
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
                        onPressed: (){
                          setState(() {
                            if (txtbut == 'SHOW') {
                              _vis = true;
                              txtbut = 'HIDE';
                              // update the question with some reward in the data base
                              // new_point = old_point + 0.5/old_point
                              print('updating the points');
                              AddtoDataBase().UpdateData(presentid);

                            } else if (txtbut == 'HIDE') {
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
                        onPressed: () async {
                          setState(() {
                            // select question based on points..
                            // iterate through the list and sort them in inc order with 1/2 prob select among the top 10%
                            // with 1/2 prob select among the 90
                            print('allquestion is printedpppppppp');
                            var new_lis = [];
                            for (var values in allque){
                              new_lis.add(values);
                            }
                            try{
                              new_lis.sort((a, b) => a['points'].compareTo(b['points']));
                            }catch(e){
                              print(e);
                              print('beautiful exception');
                            }
                            print('allquestion is printed');
                            var rng = Random();
                            int sel2 = rng.nextInt(2);
                            if(sel2 == 1){
                              // select from the last 10
                              int que_back = rng.nextInt(10)+1;
                              presentque = new_lis[allque.length-que_back]['question'];
                              presentans = new_lis[allque.length-que_back]['answer'];
                              presentid = new_lis[allque.length-que_back]['id'].toString();
                              presentpt = new_lis[allque.length-que_back]['points'].toString();

                            }
                            else{
                              // select from all
                              int que_back = rng.nextInt(allque.length);
                              presentque = new_lis[que_back]['question'];
                              presentans = new_lis[que_back]['answer'];
                              presentid = new_lis[que_back]['id'].toString();
                              presentpt = new_lis[que_back]['points'].toString();

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
                          child: const Center(
                              child: Text(
                            'NEXT',
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),

                      // very important part of program that is used to implement the database updataion
                      Visibility(
                        visible: false,
                        child: TextButton(
                          onPressed: () async {
                            AddMannualData(2).AddData('py');
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
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.bold),
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
