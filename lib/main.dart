import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const PythonCompilerApp());
}

class PythonCompilerApp extends StatelessWidget {
  const PythonCompilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Python Compiler',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PythonCompilerScreen(),
    );
  }
}

class PythonCompilerScreen extends StatefulWidget {
  const PythonCompilerScreen({super.key});

  @override
  State<PythonCompilerScreen> createState() => _PythonCompilerScreenState();
}

class _PythonCompilerScreenState extends State<PythonCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = '';

  void _runPythonCode() async {
    final code = _codeController.text;
    try {
      // Send the Python code to the backend server
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/run'), //  server URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      // Parse the response
      final result = jsonDecode(response.body);
      setState(() {
        _output = result['output'] ?? result['error'];
      });
    } catch (e) {
      setState(() {
        _output = 'Error: $e';
      });
    }
  }



  void _clearFields() {
    setState(() {
      _codeController.clear();
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Python Compiler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Python code here...',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _runPythonCode,
                  child: const Text('Run'),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Output:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
