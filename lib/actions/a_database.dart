import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddtoDataBase {
  String que;
  String ans;
  String subject;
  AddtoDataBase(this.que, this.ans, this.subject) {
    addData(que, ans, subject);
  }
  void addData(que, ans, subject) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database quefile, int version) async {
      await quefile.execute(
          'create table quetable (id integer, question text, answer text, subject text, points integer)');
    });

    // insert data into table
    await database.transaction((txn) async{
      int id1 = await txn.rawInsert(
          'insert into quetable (id, question, answer, subject, points) values(2, "$que", "$ans", "$subject", 0)'
      );
      print('inserted1 : $id1');
    });


    //count no of entries
    var count = Sqflite
        .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM quetable'));
    print('count is : $count');

    //delete
    count = await database
        .rawDelete('DELETE FROM quetable WHERE id = 2');

    // get the records
    List<Map> list = await database.rawQuery('select * from quetable where subject = "cn"');
    print('going to print list');
    print(list);

  }
}
