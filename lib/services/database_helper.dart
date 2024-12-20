import 'package:provider_app/models/student.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  Future<Database> get db async {
    // Use null-aware operator
    _db ??= await initDatabase();
    return _db!;
  }
  Future<Database> initDatabase() async {
    // Get the directory to store the database
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'student.db');
    // Open the database
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }
  // Function to create the student table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)', // Added AUTOINCREMENT for id
    );
  }
  // Function to add a student
  Future<Student> add(Student student) async {
    var dbClient = await db;
    student.id = await dbClient.insert('student', student.toMap());
    return student;
  }
  // Function to get all students
  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('student', columns: ['id', 'name']); // Added type annotations
    List<Student> students = maps.isNotEmpty ? maps.map((studentMap) => Student.fromMap(studentMap)).toList(): [];
    return students;
  }
  // Function to delete a student by id
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // Function to update student information
  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
  // Function to close the database connection
  Future<void> close() async {
    var dbClient = await db;
    await dbClient.close();
  }
}
