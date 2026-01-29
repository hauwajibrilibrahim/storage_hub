import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileStorageDemo extends StatefulWidget {
  const FileStorageDemo({super.key});

  @override
  State<FileStorageDemo> createState() => _FileStorageDemoState();
}

class _FileStorageDemoState extends State<FileStorageDemo> {
  final TextEditingController _contentController = TextEditingController();
  String _fileContents = 'File is empty or does not exist.';
  String? _filePath; // To show where the file is

  @override
  void initState() {
    super.initState();
    _readFile();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    setState(() {
      _filePath = '$path/my_demo_file.txt';
    });
    return File('$path/my_demo_file.txt');
  }

  Future<void> _saveFile() async {
    final file = await _localFile;
    // Write the file
    await file.writeAsString(_contentController.text);
    _readFile();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File saved successfully!')));
    }
  }

  Future<void> _readFile() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      setState(() {
        _fileContents = contents;
      });
    } catch (e) {
      // If encountering an error, return 0
      setState(() {
        _fileContents = 'Error reading file (maybe it doesn\'t exist yet).';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Storage Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Directly saving files is useful for large data, logs, or exporting content.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_filePath != null)
                Text(
                  'File Path:\n$_filePath',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'File Content',
                  border: OutlineInputBorder(),
                  hintText: 'Type something big here...',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _saveFile,
                icon: const Icon(Icons.save),
                label: const Text('Save to File'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Current File Content:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(_fileContents),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
