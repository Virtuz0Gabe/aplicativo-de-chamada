import "package:flutter/material.dart";
import "package:chamada/model/aluno.dart";
import "package:chamada/View/relatorio_page.dart";

// ignore: must_be_immutable
class ChamadaPage extends StatefulWidget {
  List<Aluno> chamada;
  ChamadaPage(this.chamada, {super.key});

  @override
  State<ChamadaPage> createState() => _ChamadaPageState();
}

class _ChamadaPageState extends State<ChamadaPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chamada"),
        leading: IconButton(
          alignment: Alignment.center,
          icon: const Icon(Icons.school_rounded),
          onPressed: () {

          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chamada.length,
        itemBuilder: (BuildContext context, int index) {
          bool presente = widget.chamada[index].presente; 
          Aluno aluno = widget.chamada[index];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon( 
                  aluno.sexo == "Masculino"
                  ? Icons.person
                  : Icons.person_2
                ),
                const Padding(padding: EdgeInsets.all(12)),
                Text(aluno.nome),
                Expanded(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aluno.presente ? Colors.greenAccent : Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          aluno.setPresente(!aluno.presente);
                        });
                      },
                      child: presente ? const Text("Presente") : const Text("Ausente"),
                    ),
                  ]
                )
                )
              ],
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: (Colors.tealAccent),
        label: const Text("Gerar Relatório"),
        icon: const Icon(Icons.difference_outlined),
        foregroundColor: (Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelatorioPage(widget.chamada))
          );
        },
      ),
    );
  }
}