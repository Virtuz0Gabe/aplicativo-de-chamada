import 'package:flutter/material.dart';
import 'package:chamada/View/home_page.dart';
import 'package:chamada/View/chamada_page.dart';
import 'package:chamada/model/aluno.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Aluno> chamada = [];
  int currentPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(chamada),
      ChamadaPage(chamada),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: "Alunos"),
          NavigationDestination(icon: Icon(Icons.list_rounded), label: "Chamada"),
          //NavigationDestination(icon: Icon(Icons.history), label: "Histórico de chamadas")
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );      
  }
}