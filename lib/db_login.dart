import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLhelperlog {
  static Future <void> createTables (sql.Database database) async {
    await database.execute("""CREATE TABLE login(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nombre text,
      apellidos text,
      correo text,
      contrasena text
    )""");
  }

  static Future <sql.Database> db() async {
    return sql.openDatabase('login.db', version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future <int> createDataLogin(String? nombre, String? apellidos,
   String? correo, String? contrasena) async {
    final db = await SQLhelperlog.db();
    final data = {
      'nombre' : nombre,
      'apellidos' : apellidos,
      'correo' : correo,
      'contrasena' : contrasena
    };

    final id = await db.insert('login', data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
   }

   static Future <List<Map<String, dynamic>>> getAllDataLogin() async {
    final db = await SQLhelperlog.db();
    return db.query('login', orderBy: 'id');
   }

   static Future <List<Map<String, dynamic>>> getSingleData(String correo) async {
    final db = await SQLhelperlog.db();
    return db.query('login', where:"correo=?", whereArgs: [correo]);
   }
}