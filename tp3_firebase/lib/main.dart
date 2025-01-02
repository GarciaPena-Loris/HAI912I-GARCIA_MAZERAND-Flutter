import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp3/presentation/pages/ProfilePage.dart';
import 'presentation/pages/AddQuestionPage.dart';
import 'presentation/pages/AddThemePage.dart';
import 'presentation/pages/SignInPage.dart';
import 'presentation/pages/SignUpPage.dart';
import 'presentation/screens/ProfileCardApp.dart';
import 'presentation/screens/QuizApp.dart';
import 'data/providers/ThemeProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

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
            home: FirebaseAuth.instance.currentUser == null
                ? const WelcomePage()
                : const HomePage(),
          );
        },
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans l\'application !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Continuer en tant qu\'invité'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste d\'applications'),
        centerTitle: true,
        backgroundColor: Colors.green,
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
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Déconnexion réussie !')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user == null) ...[
              {'title': 'Sign Up', 'page': const SignUpPage()},
              {'title': 'Sign In', 'page': const SignInPage()},
            ].map((item) {
              return Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item['page'] as Widget),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: Icon(Icons.arrow_forward, color: textColor),
                      label: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['title'] as String,
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }).toList(),
            ...[
              {'title': 'Exercice 2 : Quiz', 'page': const QuizApp()},
              {'title': 'Add Theme', 'page': const AddThemePage()},
              {'title': 'Add Question', 'page': const AddQuestionPage()},
              {'title': 'Profile', 'page': const ProfilePage()},
            ].map((item) {
              return Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => item['page'] as Widget),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: Icon(Icons.arrow_forward, color: textColor),
                      label: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['title'] as String,
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}