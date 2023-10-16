import 'package:flutter/material.dart';
import 'package:rememberdev/CadPadroes.dart';
import 'package:rememberdev/DatabaseHelper.dart';
import 'package:rememberdev/ListCategorias.dart';

import 'widgets/widgets_custom.dart';

class CadCategorias extends StatefulWidget {
  final String? categoria;

  const CadCategorias({Key? key, this.categoria}) : super(key: key);

  @override
  _CadCategoriasState createState() => _CadCategoriasState();
}

class _CadCategoriasState extends State<CadCategorias> {
  late TextEditingController _categoriaController;

  @override
  void initState() {
    super.initState();
    _categoriaController = TextEditingController(text: widget.categoria);
  }

  @override
  void dispose() {
    _categoriaController.dispose();
    super.dispose();
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
          title: const Center(child: Text('Nova Categoria')),
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Outros widgets da coluna...
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WidgetsCustom.categoriaTextField(context,
                        minhaVariavel: _categoriaController.text),
                    WidgetsCustom.buttonSalvarCategoria(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
