import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isDeleting = false;

  Future<void> _deletePost() async {
    if (!_formKey.currentState!.validate()) return;

    final id = _idController.text.trim();

    setState(() {
      _isDeleting = true;
    });

    final response = await http.delete(
      Uri.parse('http://localhost:8000/posts/$id'),
    );

    setState(() {
      _isDeleting = false;
    });

    if (response.statusCode == 204 || response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post deleted successfully')));
      _idController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Delete Post", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Enter Post ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter an ID' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isDeleting ? null : _deletePost,
              child: _isDeleting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
