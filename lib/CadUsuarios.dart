import 'package:flutter/material.dart';
import 'package:rememberdev/widgets/widgets_custom.dart';

class CadUsuarios extends StatefulWidget {
  const CadUsuarios({super.key});

  @override
  State<CadUsuarios> createState() => _CadUsuariosState();
}

class _CadUsuariosState extends State<CadUsuarios> {
  String _newuser = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            }),
        title: Center(child: const Text('Novo Usuário')),
        backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadPadroes(),
                  ));*/
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/newuser.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    WidgetsCustom.newusuarioTextField(context),
                    const SizedBox(height: 16),
                    WidgetsCustom.newsenhaTextField(context),
                    const SizedBox(height: 16),
                    WidgetsCustom.buttonNewUser(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
