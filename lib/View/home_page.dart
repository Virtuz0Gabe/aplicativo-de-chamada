import "package:chamada/model/aluno.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  
  List<Aluno> chamada =[];
  HomePage(this.chamada, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //==============================================
    Aluno aluno = Aluno("Gabriel", "Werner Kuhn", "Masculino", 19);
    widget.chamada.add(aluno);//=======================

    int studentsNum = widget.chamada.length;
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
      body: ListView.builder(
        itemCount: studentsNum,
        itemBuilder: (BuildContext context, int index) {
          Aluno aluno = widget.chamada[index];
          return ListTile(
            title: Text("${aluno.nome} ${aluno.sobrenome}"),
            leading: Icon( 
                aluno.sexo == "Masculino"
                ? Icons.person
                : Icons.person_2
              ),
            trailing: const Icon(Icons.info_outline_rounded),
            onTap: () {
              debugPrint("Student ${(studentsNum + 1)} Selected");
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: (Colors.tealAccent),
        label: const Text("Adiconar aluno"),
        icon: const Icon(Icons.person_add_alt_1),
        foregroundColor: (Colors.black),
        onPressed: () {
          _dialogBuilder(context);
        },
      ),
    );
  }


// ======================================== Dialog ===============================
  Future<void> _dialogBuilder(BuildContext context) {
    TextEditingController nomeCT = TextEditingController();
    TextEditingController idadeCT = TextEditingController();
    String sexo = "Masculino";

    bool isSwitch = false;
    final formKey = GlobalKey<FormState>();
    final validFormNF = ValueNotifier<bool>(false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder (builder: (context, setState) {
          return 
         AlertDialog(
            title: const Text('Insira os dados do aluno'),
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
                      const Icon(Icons.person),
                      Text("Masculino",
                      style: TextStyle(
                      color: isSwitch ? Colors.grey : Colors.teal
                    )),
                      Switch(
                      value: isSwitch,
                      onChanged: (bool newBool) {
                        setState (() {
                          isSwitch = newBool;
                          sexo = isSwitch ? "Masculino" : sexo = "Feminino";
                        });
                      }
                    ),
                    Text("Feminino",
                    style: TextStyle(
                      color: isSwitch ? Colors.teal : Colors.grey
                    )),
                    const Icon(Icons.person_2)
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
                  label: const Text("Confirmar Matrícula"),
                  icon: const Icon(Icons.check_rounded),
                  onPressed: !validForm ? null : () {
                    List<String> partes = nomeCT.text.split(" ");
                    String primeiroNome = partes[0];
                    String sobrenome = partes.sublist(1).join(' ');
        
                    Aluno novoAluno = Aluno(primeiroNome, sobrenome, sexo, int.parse(idadeCT.text));  
                    widget.chamada.add(novoAluno);
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