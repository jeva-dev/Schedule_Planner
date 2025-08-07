import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isUpdating = false;

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) return;

    final id = _idController.text.trim();
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    setState(() {
      _isUpdating = true;
    });

    final url = Uri.parse('http://localhost:8000/posts/$id');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );

    setState(() {
      _isUpdating = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post updated successfully')));
      _idController.clear();
      _titleController.clear();
      _contentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text("Update Post", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Post ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter ID' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'New Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter title' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'New Content',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Enter content' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUpdating ? null : _updatePost,
              child: _isUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
