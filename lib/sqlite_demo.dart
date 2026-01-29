import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDemo extends StatefulWidget {
  const SqliteDemo({super.key});

  @override
  State<SqliteDemo> createState() => _SqliteDemoState();
}

class _SqliteDemoState extends State<SqliteDemo> {
  Database? _database;
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
    );
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    if (_database == null) return;
    final data = await _database!.query('tasks');
    setState(() {
      _tasks = data;
    });
  }

  Future<void> _addTask() async {
    if (_database == null || _taskController.text.isEmpty) return;
    await _database!.insert('tasks', {
      'title': _taskController.text,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    _taskController.clear();
    _refreshTasks();
  }

  Future<void> _deleteTask(int id) async {
    if (_database == null) return;
    await _database!.delete('tasks', where: 'id = ?', whereArgs: [id]);
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Demo (sqflite)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'SQLite is a relational database. Good for complex queries, relations, and structured data.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'New Task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task to SQLite'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(task['title']),
                      leading: CircleAvatar(child: Text('${task['id']}')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(task['id']),
                      ),
                    ),
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
