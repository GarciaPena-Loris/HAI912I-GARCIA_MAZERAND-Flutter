import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Exercice1/ThemeSwitcher.dart';
import 'ThemeProvider.dart';
import 'Exercice1/Question1/QuizAppProviders.dart';
import 'Exercice1/Question2/ThemeSelectionPageBLoC.dart';
import 'Exercice1/Question1/QuizProvider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
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
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.purpleAccent,
        actions: [ThemeSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                ),
                icon: Icon(Icons.quiz, color: textColor),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercice 1 : Quiz (avec Provider)',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizAppProdivers(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Add space between the buttons

            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                ),
                icon: Icon(Icons.quiz, color: textColor),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exercice 2 : Quiz (avec BLoC)',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSelectionPageBLoC(),
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