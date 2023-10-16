import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rememberdev/Dialogs.dart';
import 'package:rememberdev/Providerbase.dart';
import '../DatabaseHelper.dart';
import '../ListCategorias.dart';
import '../ListPadroes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:core';

final TextEditingController _categoryController = TextEditingController();
late String _nome;
late String _senha;
late String _newuser;
late String _newpass;
late String _newcategory;
FocusNode _userFocusNode = FocusNode();
FocusNode _passFocusNode = FocusNode();
bool usuarioPermitido = false;
DateTime dataHoraAtual = DateTime.now();

const Color myColor = Color.fromRGBO(13, 97, 165, 1); // Azul
//Color myColor = Color(0xFF1B3A59);

final List<Map<String, String>> users = [];
/*final List<Map<String, String>> users = [
  {'user': '1', 'key': '1'},
  {'user': 'diogo', 'key': '123'},
  {'user': '2', 'key': '22'},
];*/

Future<void> listAllUsers() async {
  List<Map<String, dynamic>> dbUsers =
      await DatabaseHelper.instance.queryAllUsers();

  // Limpe a lista de usuários existente antes de adicionar os dados do banco de dados
  users.clear();

  // Adicione os usuários do banco de dados à lista
  for (var dbUser in dbUsers) {
    final username = dbUser['username'].toString();
    final key = dbUser['password'].toString();
    users.add({'user': username, 'key': key});
  }
}

class WidgetsCustom {
  static Widget usuarioTextField(context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          _nome = value;
        },
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Usuário',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person,
            color: myColor,
          ),
        ),
      ),
    );
  }

  static Widget newusuarioTextField(context) {
    // Ao criar o widget a variável é zerada
    _newuser = '';

    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        focusNode: _userFocusNode,
        onChanged: (value) {
          _newuser = value;
        },
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Novo usuário',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person_add,
            color: myColor,
          ),
        ),
      ),
    );
  }

  static Widget newsenhaTextField(context) {
    // Ao criar o widget a variável é zerada
    _newpass = '';

    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        focusNode: _passFocusNode,
        onChanged: (value) {
          _newpass = value;
        },
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Senha',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromRGBO(13, 97, 165, 1),
          ),
        ),
      ),
    );
  }

  static Widget senhaTextField(context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          _senha = value;
        },
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Senha',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.lock,
            color: Color.fromRGBO(13, 97, 165, 1),
          ),
        ),
      ),
    );
  }

  static Widget buttonNewUser(context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        child: Text(
          'Cadastrar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          if (_newuser.isEmpty || _newpass.isEmpty) {
            if (_newuser.isEmpty) {
              final snackBar = SnackBar(content: Text('Usuário obrigatório'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Dar foco ao campo de texto do usuário
              FocusScope.of(context).requestFocus(_userFocusNode);
            } else {
              final snackBar = SnackBar(content: Text('Senha obrigatória'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Dar foco ao campo de texto do senha
              FocusScope.of(context).requestFocus(_passFocusNode);
            }
          } else {
            Map<String, dynamic> row = {
              'username': _newuser,
              'password': _newpass,
            };
            int id = await DatabaseHelper.instance.insertUser(row);

            final snackBar =
                SnackBar(content: Text('Usuário cadastrado com sucesso'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.pop(context);
          }
        },
      ),
    );
  }

  static Widget buttonLogin(context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          await listAllUsers();
          for (int i = 0; i < users.length; i++) {
            if (_nome == users[i]['user'] && _senha == users[i]['key']) {
              authProvider.login(_nome); // Armazena o nome do usuário logado
              usuarioPermitido = true;
              break;
            }
          }

          if (usuarioPermitido) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPadroes(),
                ));
          } else {
            final snackBar = SnackBar(content: Text('Login inválido'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      ),
    );
  }

  static Widget categoriaTextField(context, {String? minhaVariavel}) {
    // Ao criar o widget a variável é zerada
    TextEditingController _categoryController =
        TextEditingController(text: minhaVariavel);
    return Container(
      height: 60,
      width: 300,
      child: TextField(
        controller: _categoryController,
        onChanged: (value) {
          _newcategory = value;
        },
        maxLines: null,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Descrição',
          border: OutlineInputBorder(),
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget buttonSalvarPadrao(BuildContext context, Function() onPressed) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        child: Text(
          'Salvar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  static Widget buttonCategorias(context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        child: Text(
          'Categorias',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListCategorias(),
              ));
        },
      ),
    );
  }

  static Widget buttonSalvarCategoria(context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInUsername = authProvider.loggedInUser;
    DateTime dataHoraAtual = DateTime.now();
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        child: Text(
          'Salvar',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          Map<String, dynamic> row = {
            'description': _newcategory,
            'username': loggedInUsername,
            'datetime': dataHoraAtual.toLocal().toString()
          };
          int id = await DatabaseHelper.instance.insertCategory(row);
          //DialogUtils dialogUtils = DialogUtils();
          Navigator.pop(context, true);
          // Ao gravar com sucesso
          // dialogUtils.showSuccessDialog(context, 'Cadastrado com sucesso');
          _categoryController.clear();
        },
      ),
    );
  }

  static Widget buttonBackCategoria(context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Voltar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final IconData icon;
  final String description;
  final Color buttonColor;
  final VoidCallback onPressed;

  const CustomTextButton({
    required this.icon,
    required this.description,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
