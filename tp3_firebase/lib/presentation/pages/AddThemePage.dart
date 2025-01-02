import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddThemePage extends StatefulWidget {
  const AddThemePage({super.key});

  @override
  AddThemePageState createState() => AddThemePageState();
}

class AddThemePageState extends State<AddThemePage> {
  final TextEditingController _themeController = TextEditingController();

  Future<void> _addTheme() async {
    final String theme = _themeController.text.trim();
    if (theme.isNotEmpty) {
      await FirebaseFirestore.instance.collection('themes').doc(theme).set({'theme': theme});
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Theme'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _themeController,
              decoration: const InputDecoration(labelText: 'Theme Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTheme,
              child: const Text('Add Theme'),
            ),
          ],
        ),
      ),
    );
  }
}