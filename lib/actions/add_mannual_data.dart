import 'package:flutter/material.dart';
import 'package:interview/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class AddMannualData{
  int su = 1;
  AddMannualData(sub){
    this.su = sub;
    print('my dear constructor $su');
  }

  void AddData(subj) async{
    // iterate through the list and add
    String que = 'trouble';
    String ans = 'trouble';
    String subject = subj;
    int id = 1;

    // retrieve database path
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    // create database if don't exist already
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database quefile, int version) async {
          await quefile.execute(
              'create table quetable (id integer, question text, answer text, subject text, points integer)');
        });

    // iterate through the question list
    if(su ==1){
      print('computerNetwork');
      for(int i=0; i+2< computerNetwork.length; i=i+2) {
        que = computerNetwork[i];
        ans = computerNetwork[i+1];
        await database.transaction((txn) async{
          String strid = id.toString();
          print('\n $id\n');
          int id1 = -1;
          try{
            id1 = await txn.rawInsert(
                'insert into quetable (id, question, answer, subject, points) values($strid, "$que", "$ans", "$subject",0)'
            );
          }catch(e){
            print('\n$id ignored dew to error\n');
          }
          print('inserted1 : $id1');
        });
        id += 1;
      }
    }
    else if(su == 2){
      print('this func is being called');
      for(int i=0; i+2< pythonQue.length; i=i+2) {
        que = pythonQue[i];
        ans = pythonQue[i+1];
        await database.transaction((txn) async{
          String strid = id.toString();
          print('\n $id\n');
          int id1 = -1;
          try{
            id1 = await txn.rawInsert(
                'insert into quetable (id, question, answer, subject, points) values($strid, "$que", "$ans", "$subject",0)'
            );
          }catch(e){
            print('\n$id ignored dew to error\n');
          }
          print('inserted1 : $id1');
        });
        id += 1;
      }
    }


    // get the records
    List<Map> list = await database.rawQuery('select * from quetable');
    print('going to print list');
    print(list);
  }
}