// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_jacket/db_login.dart';
import 'package:life_jacket/main.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Registrar extends StatefulWidget {
  const Registrar({Key? key});

  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;


  void _refreshData() async {
    final data = await SQLhelperlog.getAllDataLogin();
    setState(() {
      _allData = data;
      _isLoading = false;
      print(_allData);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

// Agregar data
  Future<void> _addData() async {
    await SQLhelperlog.createDataLogin(
        _nombreController.text,
        _apellidosController.text,
        _correoController.text,
        _contrasenaController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Color.fromARGB(255, 0, 131, 254),
        content: Text('Registro exitoso')));
    _refreshData();
  }

  Mailer() async {
  
  String username = 'jfmonsalve186@misena.edu.co';
  String password = 'ntwspcfgkeqqjenp';

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Confirmacion de registro a life jacket')
    ..recipients.add(_correoController.text)
    ..ccRecipients.addAll([_correoController.text, _correoController.text])
    ..bccRecipients.add(Address(_correoController.text))
    ..subject = 'Bienvenido al sistema de adminsitracion de life jacket ${DateTime.now()}'
    ..text = 'inicio de sesion de life jacket.'
    ..html = "aqui podrás regitrar las compras de los automoviles que ingresan al sistema";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
 
  var connection = PersistentConnection(smtpServer);
  await connection.send(message);
  await connection.close();
}
  @override
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _contrasenaAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Registrarse',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: _nombreController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor rellene este campo';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(185, 121, 121, 121),
                      ),
                    ),
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Nombre',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: _apellidosController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor rellene este campo';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(185, 121, 121, 121),
                      ),
                    ),
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Apellidos',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: _correoController,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(185, 121, 121, 121),
                      ),
                    ),
                    prefixIcon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Correo',
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  obscureText: true,
                  controller: _contrasenaController,
                  validator: (valueOne) {
                    if (valueOne == null || valueOne.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    bool passwordValid =
                        RegExp(r'^(?=.?[A-Za-z])(?=.?[0-9]).{8,}$')
                            .hasMatch(valueOne);
                    if (!passwordValid) {};
                    return null;
                  },
                  
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(185, 121, 121, 121),
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Contraseña',
                  ),
                ),  
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: TextFormField(
                  controller: _contrasenaAgainController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(185, 121, 121, 121),
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Repetir conraseña',
                  ),
                )
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  child: Text('Enviar'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Mailer();
                      _addData();
                      Navigator.push(
                      
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
