import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProfileCardApp.dart';
import 'QuizApp.dart';
import 'ThemeProvider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Combined App',
            theme: ThemeData(
              brightness: Brightness.light,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste d\'applications'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileCardApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                icon: Icon(Icons.portrait, color: textColor),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercice 1 : Carte de profil',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                icon: Icon(Icons.quiz, color: textColor),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercice 2 : Quiz',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}