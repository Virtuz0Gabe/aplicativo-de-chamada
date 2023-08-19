import 'objectbox.g.dart';
import 'package:chamada/model/aluno.dart';

class ObjectBoxDatabase {
  late final Store store;
  late final Box<Aluno> students;

  ObjectBoxDatabase._create(this.store){
    students = Box<Aluno>(store);
  }

  static Future<ObjectBoxDatabase> create() async {
    final store = await openStore();
    return ObjectBoxDatabase._create(store);
  }

 Stream<List<Aluno>> watchAll() {
    return students
      .query()
      .order(Aluno_.nome)
      .watch(triggerImmediately: true)
      .map((query) => query.find());
 } 
}