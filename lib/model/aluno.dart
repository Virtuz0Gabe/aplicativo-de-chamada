class Aluno {
  String nome;
  String sobrenome;
  String sexo;
  int idade;
  bool presente = false;

  Aluno (this.nome, this.sobrenome, this.sexo, this.idade);

  String getNome (){
    return nome;
  }

  void setPresente (bool presenca){
    presente = presenca;
  }
}

