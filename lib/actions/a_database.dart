import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AddtoDataBase {
  AddtoDataBase() {
  }
  Future<List> addData(que, ans, subject) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database quefile, int version) async {
      await quefile.execute(
          'create table quetable (id integer, question text, answer text, subject text, points integer)');
    });

    //count no of entries
    var count = Sqflite
        .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM quetable'));
    print('count is : $count');

    // insert data into table
    await database.transaction((txn) async{
      String strcount = count.toString();
      int id1 = await txn.rawInsert(
          'insert into quetable (id, question, answer, subject, points) values($strcount, "$que", "$ans", "$subject", 0)'
      );
      print('inserted1 : $id1');
    });

    // delete
    count = await database
        .rawDelete('DELETE FROM quetable where id >1000');

    // get the records
    List<Map> list = await database.rawQuery('select * from quetable');
    print('going to print list');
    print(list);
    return list;

  }
}
