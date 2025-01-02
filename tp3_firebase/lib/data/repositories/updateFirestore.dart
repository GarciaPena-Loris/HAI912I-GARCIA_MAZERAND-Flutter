import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateFirestore() async {
  final String data = await rootBundle.loadString('assets/questions/questions.json');
  final Map<String, dynamic> jsonResult = json.decode(data);

  final CollectionReference themesCollection = FirebaseFirestore.instance.collection('themes');

  for (var theme in jsonResult['themes']) {
    final themeDoc = themesCollection.doc(theme['theme']);
    await themeDoc.set({'theme': theme['theme']});

    final CollectionReference questionsCollection = themeDoc.collection('questions');
    for (var question in theme['questions']) {
      await questionsCollection.add({
        'questionText': question['questionText'],
        'isCorrect': question['isCorrect'],
      });
    }
  }
}