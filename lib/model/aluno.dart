import 'package:objectbox/objectbox.dart';

@Entity()
class Aluno {
  int id = 0;
  String nome;
  String sobrenome;
  String sexo;
  int idade;
  bool presente = false;

  Aluno (this.nome, this.sobrenome, this.sexo, this.idade);

  @Id(assignable: true)
  int get entityId => id;

  String getNome (){
    return nome;
  }

  void setPresente (bool presenca){
    presente = presenca;
  }
}

