import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLhelper {
  static Future <void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE compras(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      placa TEXT,
      vehiculo TEXT,
      modelo TEXT,
      fecha TEXT,
      precio TEXT,
      correoComprador TEXT
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('comprasss.db', version: 4,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future<int> createData(String?placa, String? vehiculo, String?modelo, 
  String? fecha, String? precio, String? correoComprador) async {
    final db = await SQLhelper.db();
    final data = {
      'placa' : placa,
      'vehiculo' : vehiculo,
      'modelo' : modelo,
      'fecha' : fecha,
      'precio' : precio,
      'correoComprador' : correoComprador
    };

    final id = await db.insert('compras', data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  static Future<List<Map<String, dynamic >>> getAllData() async {
    final db = await SQLhelper.db();
    return db.query('compras', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic >>> getSingleData(int id) async {
    final db = await SQLhelper.db();
    return db.query('compras', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(int id, String? placa, String? vehiculo, String? modelo, 
  String? fecha, String? precio, String? correoComprador) async {
    final db = await SQLhelper.db();
    final data = {
      'placa' : placa,
      'vehiculo': vehiculo,
      'modelo' : modelo,
      'fecha' : fecha,
      'precio' : precio,
      'correoComprador' : correoComprador
    };
    final result = 
      await db.update('compras', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLhelper.db();
    try{
      await db.delete('compras', where: "id=?", whereArgs: [id]);
    } catch(err) {}
  }
  
}