import 'package:chamada/database/objectbox_databse.dart';
import "package:chamada/main.dart";
import "package:chamada/model/aluno.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// ignore: must_be_immutable
class HomePage extends StatefulWidget {

  ObjectBoxDatabase objectbox;
  HomePage(this.objectbox, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    //List<Aluno> chamada = widget.objectbox.students.getAll();
    //int studentsNum = chamada.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lista de Matrículas"),
        leading: IconButton(
          alignment: Alignment.center,
          icon: const Icon(Icons.school_rounded),
          onPressed: () {
          },
        ),
      ),
      body: StreamBuilder(
        stream: objectbox.watchAll(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); 
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar os dados'); 
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.teal,
                      width: 2,
                    ),
                  ),
                  child: const Text('Nenhum aluno disponível',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                ) 
                ); 
            } else {
              List<Aluno> chamada = snapshot.data!;
          
          return ListView.builder(
            itemCount: chamada.length,
            itemBuilder: (BuildContext context, int index) {
              Aluno aluno = chamada[index];
              return Dismissible(
                key: UniqueKey(), 
                movementDuration: const Duration(seconds: 1),
                background: Container(
                  color: Colors.redAccent,
                ),
                onDismissed: (direction) {
                  widget.objectbox.students.remove(aluno.id);
                },
                child: ListTile(
                  title: Text("${aluno.nome} ${aluno.sobrenome}"),
                  leading: Icon( 
                      aluno.sexo == "Masculino"
                      ? Icons.person_2
                      : Icons.person
                    ),
                  
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    _dialogBuilder(context, aluno);
                  },
                ),
              );
            },
          );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: (Colors.tealAccent),
        label: const Text("Adiconar aluno"),
        icon: const Icon(Icons.person_add_alt_1),
        foregroundColor: (Colors.black),
        onPressed: () {
          _dialogBuilder(context, null);
        },
      ),
    );
  }


// ================|===================|===== DIALOG =====|===================|================\\
  Future<void> _dialogBuilder(BuildContext context, Aluno ?aluno) {

    TextEditingController nomeCT = TextEditingController();
    TextEditingController idadeCT = TextEditingController();
    String sexo = "Masculino";
    bool isSwitch = false;

    if (aluno != null){
      nomeCT.text = "${aluno.nome} ${aluno.sobrenome}";
      idadeCT.text = (aluno.idade).toString();
      sexo = aluno.sexo;
      sexo != "Masculino" 
        ? isSwitch = false
        : isSwitch = true;
    }
    
    final formKey = GlobalKey<FormState>();
    final validFormNF = ValueNotifier<bool>(false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder (builder: (context, setState) {
          return 
         AlertDialog(
            title: aluno!= null
              ? const Text("Atulize os dados da matrícula")
              : const Text('Insira os dados do aluno'),
            content: SizedBox(
              height: 200,
              child: Form(
                onChanged: () {
                  validFormNF.value = formKey.currentState?.validate() ?? false;
                },
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    controller: nomeCT,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-z A-Z á-ú Á-Ú]')
                      )
                    ],
                    decoration: const InputDecoration(
                      label: Text("Nome completo do aluno"),  
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return "Campo vazio";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: idadeCT,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    decoration: const InputDecoration(
                      label: Text("Idade"),  
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || int.parse(value) < 17){
                        return "O aluno não possui idade suficiente para se matricular";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: isSwitch ? Colors.grey : Colors.teal,
                        ),
                      Text("Masculino",
                      style: TextStyle(
                      color: isSwitch ? Colors.grey : Colors.teal,
                      fontWeight: isSwitch ? FontWeight.normal : FontWeight.bold
                    )),
                      Switch(
                      value: isSwitch,
                      onChanged: (bool newBool) {
                        setState (() {
                          isSwitch = newBool;
                          sexo = isSwitch ? "Masculino" : sexo = "Feminino";
                        });
                      },
                      activeColor: Colors.teal,
                      activeTrackColor: Colors.teal,
                      inactiveThumbColor: Colors.teal,
                      inactiveTrackColor: Colors.teal,
                    ),
                    Text("Feminino",
                    style: TextStyle(
                      color: isSwitch ? Colors.teal : Colors.grey,
                      fontWeight: isSwitch ? FontWeight.bold : FontWeight.normal
                    )),
                     Icon(
                      Icons.person_2,
                      color: isSwitch ? Colors.teal : Colors.grey,)
                    ],
                  ),
                ]
              )
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ValueListenableBuilder <bool> (valueListenable: validFormNF,
              builder: (_, validForm, child) {
                return
                ElevatedButton.icon(
                  label: aluno!= null  
                    ? const Text("Atualizar Matŕicula")
                    : const Text("Confirmar Matrícula"),
                  icon: const Icon(Icons.check_rounded),
                  onPressed: !validForm ? null : () {
                    List<String> partes = nomeCT.text.split(" ");
                    String primeiroNome = partes[0];
                    String sobrenome = partes.sublist(1).join(' ');
        
                    if (aluno != null){
                      aluno.nome = primeiroNome;
                      aluno.sobrenome = sobrenome;
                      aluno.idade = int.parse(idadeCT.text);
                      aluno.sexo = sexo;
                      widget.objectbox.students.put(aluno);
                    } else {
                      Aluno novoAluno = Aluno(primeiroNome, sobrenome, sexo, int.parse(idadeCT.text));
                      widget.objectbox.students.put(novoAluno);
                    }
                    Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          );
          }
        );
      },
    );
  }
}