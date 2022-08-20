import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DeleteEntry{

  void delete_using_id(question_id) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database quefile, int version) async {
          await quefile.execute(
              'create table quetable (id integer, question text, answer text, subject text, points integer)');
        });

    // delete
    await database.rawDelete('DELETE FROM quetable where id == $question_id');

    print('delete performed :(');

  }
}