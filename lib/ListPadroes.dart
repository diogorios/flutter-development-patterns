import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberdev/CadPadroes.dart';
import 'package:rememberdev/DatabaseHelper.dart';
import 'widgets/widgets_custom.dart';

const baseUrl = 'https://developer-pattern-default-rtdb.firebaseio.com/';

/*final List<Map<String, String>> listaItens = [
  {'titulo': 'BD', 'subtitulo': 'Funções para valores monetários'},
  {'titulo': 'Delphi', 'subtitulo': 'Usar sempre ApplyUpdates(0)'},
  {'titulo': 'Tortoise', 'subtitulo': 'Comitar sempre ...'},
  {'titulo': 'BD', 'subtitulo': 'Select - Usar somente campos'},
  {'titulo': 'Delphi', 'subtitulo': 'Identação de código'},
];*/

class ListPadroes extends StatefulWidget {
  @override
  _ListPadroesState createState() => _ListPadroesState();
}

class _ListPadroesState extends State<ListPadroes> {
  List<Map<String, String>> listaItens = [];

  @override
  void initState() {
    super.initState();
    listAllPattern();
  }

  void listAllPattern() async {
    List<Map<String, dynamic>> dbCategorys =
        await DatabaseHelper.instance.queryAllPattern();

    setState(() {
      listaItens.clear();

      for (var dbCategory in dbCategorys) {
        listaItens.add({
          'titulo': dbCategory['description'].toString(),
          'subtitulo': dbCategory['category'].toString(),
          'id': dbCategory['id'].toString()
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmação'),
                    content: Text('Deseja sair do aplicativo?'),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                      ),
                      TextButton(
                        child: Text('Sair'),
                        onPressed: () {
                          SystemNavigator.pop(); // Fecha o aplicativo
                        },
                      ),
                    ],
                  );
                },
              );
            }),
        title: Center(child: Text('Padrões em produção')),
        backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final cadastroConcluido = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadPadroes(),
                ),
              );

              // Verifique se o cadastro foi concluído com sucesso
              if (cadastroConcluido == true) {
                // Se o cadastro foi concluído com sucesso, recarregue a lista de itens
                listAllPattern();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listaItens.length,
        itemBuilder: (BuildContext context, int index) {
          // zebra o lista
          bool isEven = index % 2 == 0;
          Color? backgroundColor = isEven ? Colors.grey[200] : Colors.white;

          return GestureDetector(
            onTap: () {
              // Obtenha o valor selecionado

              String valorSelecionadoSub = listaItens[index]['subtitulo']!;
              String valorSelecionadoTit = listaItens[index]['titulo']!;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadPadroes(
                        descricao: valorSelecionadoTit,
                        categoria: valorSelecionadoSub),
                  ));
            },
            child: Container(
              color: backgroundColor,
              child: ListTile(
                title: Text(listaItens[index]['titulo']!),
                subtitle: Text(listaItens[index]['subtitulo']!),
                trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmação'),
                          content: Text('Deseja apagar este registro?'),
                          actions: [
                            TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Fecha o diálogo
                              },
                            ),
                            TextButton(
                              child: Text('Apagar'),
                              onPressed: () async {
                                final dbHelper = DatabaseHelper
                                    .instance; // Crie uma instância de DatabaseHelper
                                await dbHelper.deletePattern(
                                    int.parse(listaItens[index]['id']!));

                                // Remova o item da lista após a exclusão
                                setState(() {
                                  listaItens.removeWhere((item) =>
                                      item['id'] == listaItens[index]['id']!);
                                });

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(121, 131, 136, 1),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
