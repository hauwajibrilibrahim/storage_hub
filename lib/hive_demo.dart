import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDemo extends StatefulWidget {
  const HiveDemo({super.key});

  @override
  State<HiveDemo> createState() => _HiveDemoState();
}

class _HiveDemoState extends State<HiveDemo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Box name
  static const String boxName = 'peopleBox';

  // We'll store data as Map<String, dynamic> for simplicity without adapters
  List<Map<dynamic, dynamic>> _people = [];

  @override
  void initState() {
    super.initState();
    _refreshPeople();
  }

  Future<void> _refreshPeople() async {
    final box = await Hive.openBox(boxName);
    setState(() {
      // Hive keys are auto-incrementing integers if we use add()
      // We convert values to a list of maps for display
      _people = box.keys.map((key) {
        final value = box.get(key);
        return {'key': key, 'name': value['name'], 'age': value['age']};
      }).toList();
    });
  }

  Future<void> _addPerson() async {
    final box = await Hive.openBox(boxName);
    await box.add({'name': _nameController.text, 'age': _ageController.text});
    _nameController.clear();
    _ageController.clear();
    _refreshPeople();
  }

  Future<void> _deletePerson(int key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
    _refreshPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Database Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Hive is a fast, lightweight, NoSQL KV database. Good for storing lists of objects quickly.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addPerson,
              child: const Text('Add Person to Hive Box'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _people.length,
                itemBuilder: (context, index) {
                  final person = _people[index];
                  return Card(
                    color: Colors.amber.shade50,
                    child: ListTile(
                      title: Text(person['name'] ?? 'Unknown'),
                      subtitle: Text('Age: ${person['age']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePerson(person['key']),
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
