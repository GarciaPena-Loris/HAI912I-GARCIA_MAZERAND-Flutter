import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ThemeProvider.dart';
import 'QuizPage.dart';

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choix du thème'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          Row(
            children: [
              if (!isDarkMode) const Icon(Icons.wb_sunny, color: Colors.yellow),
              Switch(
                value: isDarkMode,
                onChanged: themeProvider.toggleTheme,
                activeColor: Colors.black,
              ),
              if (isDarkMode) const Icon(Icons.nightlight_round, color: Colors.yellow),
            ],
          ),
        ],
      ),
      body: const ThemeSelectionPage(),
    );
  }
}

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  ThemeSelectionPageState createState() => ThemeSelectionPageState();
}

class ThemeSelectionPageState extends State<ThemeSelectionPage> {
  List<dynamic> themes = [];

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    final String data = await rootBundle.loadString('assets/questions/questions.json');
    final Map<String, dynamic> jsonResult = json.decode(data);
    setState(() {
      themes = jsonResult['themes'];
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'Histoire':
        return Icons.history_edu;
      case 'Géographie':
        return Icons.public;
      case 'Science':
        return Icons.science;
      case 'Littérature':
        return Icons.menu_book;
      case 'Cinéma':
        return Icons.movie;
      case 'Musique':
        return Icons.music_note;
      case 'Technologie':
        return Icons.devices;
      case 'Sport':
        return Icons.sports_soccer;
      case 'Art':
        return Icons.palette;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: themes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  themes[index]['theme'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(_getIconData(themes[index]['theme']), color: Colors.deepOrangeAccent),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(theme: themes[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}