import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ThemeProvider.dart';
import 'ThemeSwitcher.dart';

class ResultPage extends StatelessWidget {
  final int score;
  const ResultPage({super.key, required this.score});

  String _getComment() {
    if (score == 10) {
      return "Excellent! Tu as gagné un biscuit ! 😃";
    } else if (score >= 7) {
      return "Bien joué 😊";
    } else if (score >= 4) {
      return "Pas mal. 😐";
    } else {
      return "Peut mieux faire... 😢";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultats"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        actions: [ThemeSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Votre score : $score / 10",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _getComment(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                minimumSize: const Size(140, 40),
              ),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                "Accueil",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}