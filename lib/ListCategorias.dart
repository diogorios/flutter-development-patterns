import 'package:flutter/material.dart';
import 'package:rememberdev/CadCategorias.dart';
import 'package:rememberdev/CadPadroes.dart';
import 'package:rememberdev/DatabaseHelper.dart';

class ListCategorias extends StatefulWidget {
  @override
  _ListCategoriasState createState() => _ListCategoriasState();
}

class _ListCategoriasState extends State<ListCategorias> {
  List<Map<String, String>> listaItens = [];

  @override
  void initState() {
    super.initState();
    listAllCategory();
  }

  void listAllCategory() async {
    List<Map<String, dynamic>> dbCategorys =
        await DatabaseHelper.instance.queryAllCategory();

    setState(() {
      listaItens.clear();

      for (var dbCategory in dbCategorys) {
        listaItens.add({
          'titulo': dbCategory['description'].toString(),
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
              Navigator.pop(context);
            },
          ),
          title: Center(child: Text('Categorias em produção')),
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final cadastroConcluido = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadCategorias(),
                  ),
                );

                // Verifique se o cadastro foi concluído com sucesso
                if (cadastroConcluido == true) {
                  // Se o cadastro foi concluído com sucesso, recarregue a lista de categorias
                  listAllCategory();
                }
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: listaItens.length,
          itemBuilder: (BuildContext context, int index) {
            // zebra a lista
            bool isEven = index % 2 == 0;
            Color? backgroundColor = isEven ? Colors.grey[200] : Colors.white;
            return GestureDetector(
              onTap: () {
                // Obtenha o valor selecionado
                String valorSelecionadoTit = listaItens[index]['titulo']!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadCategorias(categoria: valorSelecionadoTit),
                  ),
                );
              },
              child: Container(
                color: backgroundColor,
                child: ListTile(
                  title: Text(listaItens[index]['titulo']!),
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
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Apagar'),
                                onPressed: () async {
                                  final dbHelper = DatabaseHelper
                                      .instance; // Crie uma instância de DatabaseHelper
                                  await dbHelper.deleteCategory(
                                      int.parse(listaItens[index]['id']!));

                                  // Remova o item da lista após a exclusão
                                  setState(() {
                                    listaItens.removeAt(index);
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
      ),
    );
  }
}
