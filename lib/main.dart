// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_jacket/db_login.dart';
import 'package:life_jacket/registrar.dart';
import 'package:life_jacket/home_screen.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) :super(key: key);

  @override
  Widget build (BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override 
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  void _Login() async {
    final correo = _correoLoginController.text;
    final contrasena = _contrasenaLoginController.text;

    List<Map<String, dynamic>> result = 
      await SQLhelperlog.getSingleData(correo);

      if(result.length == 1 && result[0]['contrasena'] == contrasena) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Text('Verifica los datos')));
      }
  }

  final _correoLoginController = TextEditingController();
  final _contrasenaLoginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      backgroundColor: Colors.blueAccent,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              child: TextFormField(
                controller: _correoLoginController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }

                  bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);

                  if(!emailValid) {
                    return 'ingrese un correo valido.';
                  }
                  return null;

                },
                obscureText: false,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3, color: Color.fromARGB(185, 121, 121, 121)
                    )
                  ),
                  prefixIcon: Icon(Icons.person),
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true, 
                  labelText: 'Usuario'),
              )
        ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: TextFormField(
                controller: _contrasenaLoginController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su contraseña';
                  }
                  bool passwordValid =
                      RegExp(r'^(?=.?[A-Za-z])(?=.?[0-9]).{8,}$')
                          .hasMatch(value);
                  if (!passwordValid) {
                    return null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Color.fromARGB(185, 121, 121, 121)),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  labelText: 'Contraseña',
                ),
              ),
            ), 
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _Login();
                  } else {
                    setState(() {});
                  }
                },
                child: Text('Ingresar')),
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                '¿Aun no tienes cuenta?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text('Registrate aqui'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Registrar()),
                  );
                },
              ),
            ), 
          ],
        ),
      ),
    );
  }


}