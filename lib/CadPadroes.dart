import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rememberdev/DatabaseHelper.dart';
import 'package:rememberdev/Dialogs.dart';
import 'package:rememberdev/ListCategorias.dart';
import 'package:rememberdev/Providerbase.dart';
import 'widgets/widgets_custom.dart';

String? selectedOptionTeste;

class MyDropdown extends StatefulWidget {
  final String? pCategoria;

  MyDropdown({this.pCategoria});
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? selectedOption;
  //List<String> options = ['Delphi', 'Tortoise', 'BD'];
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    // Definir o valor selecionado com base na variável categoria
    selectedOption = widget.pCategoria;
    fetchCategoryDescriptions();
  }

  void fetchCategoryDescriptions() async {
    List<Map<String, dynamic>> categories =
        await DatabaseHelper.instance.queryAllCategory();

    setState(() {
      options.clear();
      for (var category in categories) {
        options.add(category['description'].toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue;
          selectedOptionTeste = newValue;
        });
        print('Opção selecionada: $newValue');
      },
      style: TextStyle(
        color: Colors.black, // Cor do texto quando o dropdown está aberto
        fontSize: 16,
      ),
      selectedItemBuilder: (BuildContext context) {
        return options.map<Widget>((String option) {
          return Text(
            option,
            style: TextStyle(
              fontSize: 16,
            ),
          );
        }).toList();
      },
    );
  }
}

class CadPadroes extends StatefulWidget {
  final String? descricao;
  final String? categoria;

  const CadPadroes({Key? key, this.descricao, this.categoria})
      : super(key: key);

  @override
  _CadPadroesState createState() => _CadPadroesState();
}

class _CadPadroesState extends State<CadPadroes> {
  late TextEditingController _descricaoController;
  String? selectedCategoria;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.descricao);
    selectedCategoria = widget.categoria;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  // Função para salvar o padrão no banco de dados SQLite
  Future<void> salvarPadrao() async {
    final descricao = _descricaoController.text;
    final categoria = selectedOptionTeste ?? 'Delphi';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //print(selectedOptionTeste);
    if (descricao.isNotEmpty) {
      final padrao = Padrao(
        descricao: _descricaoController.text,
        categoria: categoria,
        loggedInUsername: authProvider.loggedInUser!,
        dataHoraAtual: DateTime.now(),
      );
      final databaseHelper = DatabaseHelper.instance;

      await databaseHelper.insertPattern(padrao);

      Navigator.pop(context, true);
      // Limpa os campos
      _descricaoController.clear();

      setState(() {
        selectedCategoria = null;
      });
    } else {
      // Exiba uma mensagem de erro se o campo de descrição estiver vazio
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Descrição é um campo obrigatório.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
          title: Center(child: Text('Novo Padrão')),
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _descricaoController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Descrição',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(child: MyDropdown(pCategoria: selectedCategoria)),
              SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WidgetsCustom.buttonSalvarPadrao(context, salvarPadrao),
                  WidgetsCustom.buttonCategorias(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
