// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_jacket/db_helper.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:life_jacket/registrar.dart';

class HomeScreen extends StatefulWidget{
  @override 
  State<HomeScreen> createState () => _HomeScreenState();
}

class _HomeScreenState extends State <HomeScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy');

  DateTime _fecha = DateTime.now();
  Future<void> _selectDate (BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2400),
    );

    if(picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
        _fechaController.text = DateFormat.yMd().format(_fecha);
      });
    }
  }

    List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  void _refreshData() async {
    final data = await SQLhelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  
  Future<void> _addData() async {
    await SQLhelper.createData(
        _placaController.text,
        _vehiculoController.text,
        _modeloController.text,
        _fechaController.text,
        _precioController.text,
        _correoCompradorController.text
        );
    _refreshData();
  }

//Actualizar data
  Future<void> _updateData(int id) async {
    await SQLhelper.updateData(
        id,
        _placaController.text,
        _vehiculoController.text,
        _modeloController.text,
        _fechaController.text,
        _precioController.text,
        _correoCompradorController.text
        );
    _refreshData();
  }

//Eliminar data
  void _deleteData(int id) async {
    await SQLhelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent, content: Text('Compra eliminda')));
    _refreshData();
  }
  Mailer() async {
  
  String username = 'jfmonsalve186@misena.edu.co';
  String password = 'ntwspcfgkeqqjenp';

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Confirmacion de compra en life jacket Vehiculos S&S')
    ..recipients.add(_correoCompradorController.text)
    ..ccRecipients.addAll([_correoCompradorController.text, _correoCompradorController.text])
    ..bccRecipients.add(Address(_correoCompradorController.text))
    ..subject = 'Bienvenido al sistema de adminsitracion de life jacket ${DateTime.now()}'
    ..text = 'inicio de sesion de life jacket.'
    ..html = 'el usuario realizo la compra de ${_vehiculoController.text} con placa ${_placaController.text} y con el precio de ${_precioController.text}, Tiene 5 dias habiles para pasar por el vehiculo a la direccion : Cra54 # 78-109 Laureles Medellin';

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
  final _placaController = TextEditingController();
  final _vehiculoController = TextEditingController();
  final _modeloController = TextEditingController();
  final _fechaController = TextEditingController();
  final _precioController = TextEditingController();
  final _correoCompradorController = TextEditingController();
  
  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _placaController.text = existingData['placa'];
      _vehiculoController.text = existingData['vehiculo'];
      _modeloController.text = existingData['modelo'];
      _fechaController.text = existingData['fecha'];
      _precioController.text = existingData['precio'];
      _correoCompradorController.text = existingData['correoComprador'];
    }
  
    showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _placaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.ad_units_rounded),
                  labelText: "Placa",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la placa';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _vehiculoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.car_crash),
                  labelText: 'Vehiculo',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el vehiculo';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                  labelText: "Modelo",
                ),
                 validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el modelo';
                  }
                  return null;
                },  
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _precioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.price_change),
                  labelText: 'Precio',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio del vehiculo';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: _correoCompradorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_card_sharp),
                  labelText: 'Correo Comprador',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo del comprador';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  
                  if (id == null) {
                    await _addData();
                  }
                  if (id != null) {
                    await _updateData(id);
                  }

                  Mailer();
                  _placaController.text = "";
                  _vehiculoController.text = "";
                  _modeloController.text = "";
                  _fechaController.text = "";
                  _precioController.text = "";
                  _correoCompradorController.text = "";

                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Añadir compra" : "Actualizar compra",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFECEAF4),
        appBar: AppBar(
          title: Text('Compras'),
        ),
        body: _isLoading
            ? SingleChildScrollView(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(_allData[index]['placa']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehiculo: ${_allData[index]['vehiculo']}'),
                            Text('Modelo: ${_allData[index]['modelo']}'),
                            Text('Fecha: ${_allData[index]['fecha']}'),
                            Text('Precio: ${_allData[index]['precio']}'),
                            Text('Correo comprador: ${_allData[index]['correoComprador']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    showBottomSheet(_allData[index]['id']);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _deleteData(_allData[index]['id']);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
        floatingActionButton: FloatingActionButton(
            onPressed: () => showBottomSheet(null), child: Icon(Icons.add), 
            ));
  }
}