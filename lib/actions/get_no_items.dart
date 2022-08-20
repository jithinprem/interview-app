import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

int totalcount = 40;

Future get_total_items() async{

  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database quefile, int version) async {
        await quefile.execute(
            'create table quetable (id integer, question text, answer text, subject text, points integer)');
      });

  var count = Sqflite
      .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM quetable'));
  print('count is : $count');
  totalcount = count!;
  return count;
}