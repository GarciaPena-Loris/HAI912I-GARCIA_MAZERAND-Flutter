import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ResultPage.dart';
import 'ThemeProvider.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> theme;

  const QuizPage({super.key, required this.theme});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<dynamic> questions;
  int currentQuestionIndex = 0;
  List<String?> answers = List.filled(10, null); // Liste des réponses

  @override
  void initState() {
    super.initState();
    questions = _getRandomQuestions(widget.theme['questions']);
  }

  // Sélection de 10 questions aléatoires
  List<dynamic> _getRandomQuestions(List<dynamic> allQuestions) {
    final random = Random();
    final List<dynamic> selectedQuestions = [];
    while (selectedQuestions.length < 10) {
      final question = allQuestions[random.nextInt(allQuestions.length)];
      if (!selectedQuestions.contains(question)) {
        selectedQuestions.add(question);
      }
    }
    return selectedQuestions;
  }

  void _submitAnswer(bool userChoice) {
    setState(() {
      answers[currentQuestionIndex] = userChoice ? "Vrai" : "Faux";
    });

    // Si toutes les questions sont répondues, afficher la page de résultats
    if (answers.every((a) => a != null)) {
      Future.delayed(const Duration(seconds: 2), () {
        int score = 0;
        for (int i = 0; i < answers.length; i++) {
          if ((answers[i] == "Vrai" && questions[i]['isCorrect'] == true) ||
              (answers[i] == "Faux" && questions[i]['isCorrect'] == false)) {
            score++;
          }
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(score: score),
          ),
        );
      });
    } else {
      // Attendre 1 seconde avant de passer à la question suivante
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final currentQuestion = questions[currentQuestionIndex];
    final userAnswer = answers[
        currentQuestionIndex]; // Réponse de l'utilisateur pour cette question

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.theme['theme']}",
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Affichage de l'image
              Image.asset(
                'assets/images/${widget.theme['theme']}.png',
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Affichage de la question
              Center(
                child: Text(
                  currentQuestion['questionText'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Boutons "Vrai" et "Faux" côte à côte
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userAnswer == null
                            ? null // Pas encore répondu
                            : (userAnswer == "Vrai" &&
                                    currentQuestion['isCorrect'] == true)
                                ? Colors
                                    .green // Correct et utilisateur a choisi Vrai
                                : (userAnswer == "Vrai" &&
                                        currentQuestion['isCorrect'] == false)
                                    ? Colors
                                        .red // Faux et utilisateur a choisi Vrai
                                    : null, // Autre bouton sans fond
                        minimumSize: const Size(130, 50), // Taille agrandie
                        side: userAnswer == null
                            ? const BorderSide(
                                color: Colors
                                    .deepOrangeAccent) // Bordure orange si pas encore répondu
                            : BorderSide.none,
                      ),
                      onPressed: userAnswer == null
                          ? () => _submitAnswer(true)
                          : () {}, // Désactivé si déjà répondu
                      child: Text(
                        "Vrai",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userAnswer == null
                            ? null // Pas encore répondu
                            : (userAnswer == "Faux" &&
                                    currentQuestion['isCorrect'] == false)
                                ? Colors
                                    .green // Correct et utilisateur a choisi Faux
                                : (userAnswer == "Faux" &&
                                        currentQuestion['isCorrect'] == true)
                                    ? Colors
                                        .red // Faux et utilisateur a choisi Faux
                                    : null, // Autre bouton sans fond
                        minimumSize: const Size(130, 50), // Taille agrandie
                        side: userAnswer == null
                            ? const BorderSide(
                                color: Colors
                                    .deepOrangeAccent) // Bordure orange si pas encore répondu
                            : BorderSide.none,
                      ),
                      onPressed: userAnswer == null
                          ? () => _submitAnswer(false)
                          : () {}, // Désactivé si déjà répondu
                      child: Text(
                        "Faux",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Stepper en deux lignes
              SizedBox(
                height: 100, // Double ligne
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // Deux lignes de 5
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestionIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: answers[index] == null
                              ? Colors.grey
                              : answers[index] == "Vrai" &&
                                      questions[index]['isCorrect'] == true
                                  ? Colors.green
                                  : answers[index] == "Faux" &&
                                          questions[index]['isCorrect'] == false
                                      ? Colors.green
                                      : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: index == currentQuestionIndex
                              ? Border.all(color: textColor, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: index == currentQuestionIndex
                              ? TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)
                              : TextStyle(color: textColor),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Navigation entre questions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: currentQuestionIndex > 0
                        ? () {
                            setState(() {
                              currentQuestionIndex--;
                            });
                          }
                        : null,
                    icon: Icon(Icons.arrow_back, color: textColor),
                    label: Text(
                      "Précédent",
                      style: TextStyle(color: textColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      // Couleur du thème
                      minimumSize: const Size(140, 40), // Taille uniforme
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: currentQuestionIndex < 9
                        ? () {
                            setState(() {
                              currentQuestionIndex++;
                            });
                          }
                        : null,
                    label: Text(
                      "Suivant",
                      style: TextStyle(color: textColor),
                    ),
                    icon: Icon(Icons.arrow_forward, color: textColor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      // Couleur du thème
                      minimumSize: const Size(140, 40), // Taille uniforme
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
