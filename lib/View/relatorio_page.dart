import "package:flutter/material.dart";
import 'package:chamada/model/aluno.dart';

class RelatorioPage extends StatefulWidget {
  List<Aluno> chamada;
  RelatorioPage(this.chamada, {super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {

  @override
  Widget build(BuildContext context) {
    //int studentsNum = widget.chamada.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Relatório de presença"),
        leading: IconButton(
          alignment: Alignment.center,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chamada.length,
        itemBuilder: (BuildContext context, int index) {
          Aluno aluno = widget.chamada[index];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text('${aluno.nome} ${aluno.sobrenome}'),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        aluno.presente 
                        ? Icons.check_rounded
                        : Icons.close_rounded
                      ),
                      Text(aluno.presente
                      ? "Presente"
                      : "Ausente"
                      )
                    ],
                  )
                )
              ],
            ),
          );
        },
      )
    );
  }
}