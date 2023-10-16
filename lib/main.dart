import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rememberdev/CadUsuarios.dart';
import 'package:rememberdev/Providerbase.dart';
import 'package:rememberdev/Splash.dart';
import 'package:provider/provider.dart';
import 'widgets/widgets_custom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      projectId: 'developer-pattern',
      apiKey: 'AIzaSyDATxjb7JUsBtXql0lxcP5NcOg-YN1AdGA',
      appId: '1:373667761285:android:9b08e616e6bef4dd1fedec',
      messagingSenderId: '373667761285',
    ),
  );

  // Grava o usuário logado
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Splash());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
        title: Center(child: const Text('Guia do Desenvolvedor')),
        backgroundColor: Color.fromRGBO(13, 97, 165, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadUsuarios(),
                  ));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/login.jpeg'),
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
                    // Exemplo: listUsers(_firebaseFirestore.collection('users')),
                    const SizedBox(height: 16),
                    WidgetsCustom.usuarioTextField(context),
                    const SizedBox(height: 16),
                    WidgetsCustom.senhaTextField(context),
                    const SizedBox(height: 16),
                    WidgetsCustom.buttonLogin(context),
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

Widget listUsers(CollectionReference users) {
  return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((e) => Text(e['name'])).toList());
      }));
}
