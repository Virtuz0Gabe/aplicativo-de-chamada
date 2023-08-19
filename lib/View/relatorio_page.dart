import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chamada/model/aluno.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class RelatorioPage extends StatefulWidget {
  List<Aluno> chamada;
  RelatorioPage(this.chamada, {super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  final pdf = pw.Document();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              salvarPdf(widget.chamada);
            }
          )
        ],
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



  Future<void> salvarPdf(List<Aluno> chamada) async {
    gerarPdf(chamada);
  
    final Directory pdfDir = Directory('/storage/emulated/0/Download/pdfs');
    pdfDir.createSync(recursive: true);

    final String pdfPath = '${pdfDir.path}/relatorio.pdf';
    final File pdfFile = File(pdfPath);
    pdfFile.writeAsBytesSync( await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pdf Salvo com sucesso em: $pdfPath")),
    );
  }
    
   void gerarPdf (List<Aluno> chamada) {
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.ListView(
          children: [
            pw.Center(
              child: 
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.all(16),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "Relatório de presença",
                        style: pw.TextStyle (
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text (
                        "Data: ${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now())}",
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Divider(),
              buildList(chamada),
            ],
          );
        },
    ));
   }

    pw.Widget buildList(List<Aluno> chamada) {
      final alunosWidgets = widget.chamada.map((aluno) {
        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("${aluno.nome} ${aluno.sobrenome}"),
            pw.Text(aluno.presente ? "Presente" : "Ausente"),
          ],
        );
      }).toList();

      return pw.Column(children: alunosWidgets);
    }
  }

