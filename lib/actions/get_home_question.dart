import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GetQue{
  Future<List> get_home_question(que_sub) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database quefile, int version) async {
          await quefile.execute(
              'create table quetable (id integer, question text, answer text, subject text, points integer)');
        });

    que_sub = que_sub.toString();
    List<Map> list = await database.rawQuery('select question, answer, id, points from quetable where subject = "$que_sub"');
    return list;
  }
}