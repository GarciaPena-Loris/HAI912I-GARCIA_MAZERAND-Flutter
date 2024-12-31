import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/ResultPage.dart';
import '../../data/providers/ThemeProvider.dart';
import '../../data/providers/QuizProvider.dart';

class QuizProviders extends StatefulWidget {
  final Map<String, dynamic> theme;

  const QuizProviders({super.key, required this.theme});

  @override
  _QuizProvidersState createState() => _QuizProvidersState();
}

class _QuizProvidersState extends State<QuizProviders> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.setQuestions(_getRandomQuestions(widget.theme['questions']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.theme['theme']}"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        actions: [
          Row(
            children: [
              if (Provider.of<ThemeProvider>(context).themeMode != ThemeMode.dark)
                const Icon(Icons.wb_sunny, color: Colors.yellow),
              Switch(
                value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
                },
                activeColor: Colors.black,
              ),
              if (Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark)
                const Icon(Icons.nightlight_round, color: Colors.yellow),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.questions.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentQuestion = quizProvider.questions[quizProvider.currentQuestionIndex];
              final userAnswer = quizProvider.answers[quizProvider.currentQuestionIndex];
              final textColor = Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/images/${widget.theme['theme']}.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      currentQuestion['questionText'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userAnswer == null
                                ? null
                                : (userAnswer == "Vrai" && currentQuestion['isCorrect'] == true)
                                    ? Colors.green
                                    : (userAnswer == "Vrai" && currentQuestion['isCorrect'] == false)
                                        ? Colors.red
                                        : null,
                            minimumSize: const Size(130, 50),
                            side: userAnswer == null
                                ? const BorderSide(color: Colors.purpleAccent)
                                : BorderSide.none,
                          ),
                          onPressed: userAnswer == null
                              ? () {
                                  quizProvider.submitAnswer(true);
                                  if (quizProvider.allQuestionsAnswered()) {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultPage(score: quizProvider.calculateScore()),
                                        ),
                                      );
                                    });
                                  } else {
                                    Future.delayed(const Duration(seconds: 1), () {
                                      quizProvider.nextQuestion();
                                    });
                                  }
                                }
                              : null,
                          child: Text("Vrai", style: TextStyle(color: textColor)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userAnswer == null
                                ? null
                                : (userAnswer == "Faux" && currentQuestion['isCorrect'] == false)
                                    ? Colors.green
                                    : (userAnswer == "Faux" && currentQuestion['isCorrect'] == true)
                                        ? Colors.red
                                        : null,
                            minimumSize: const Size(130, 50),
                            side: userAnswer == null
                                ? const BorderSide(color: Colors.purpleAccent)
                                : BorderSide.none,
                          ),
                          onPressed: userAnswer == null
                              ? () {
                                  quizProvider.submitAnswer(false);
                                  if (quizProvider.allQuestionsAnswered()) {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultPage(score: quizProvider.calculateScore()),
                                        ),
                                      );
                                    });
                                  } else {
                                    Future.delayed(const Duration(seconds: 1), () {
                                      quizProvider.nextQuestion();
                                    });
                                  }
                                }
                              : null,
                          child: Text("Faux", style: TextStyle(color: textColor)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: quizProvider.questions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            quizProvider.currentQuestionIndex = index;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: quizProvider.answers[index] == null
                                  ? Colors.grey
                                  : quizProvider.answers[index] == "Vrai" &&
                                          quizProvider.questions[index]['isCorrect'] == true
                                      ? Colors.green
                                      : quizProvider.answers[index] == "Faux" &&
                                              quizProvider.questions[index]['isCorrect'] == false
                                          ? Colors.green
                                          : Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: index == quizProvider.currentQuestionIndex
                                  ? Border.all(color: textColor, width: 2)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${index + 1}",
                              style: index == quizProvider.currentQuestionIndex
                                  ? TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)
                                  : TextStyle(color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: quizProvider.currentQuestionIndex > 0
                            ? () {
                                quizProvider.previousQuestion();
                              }
                            : null,
                        icon: Icon(Icons.arrow_back, color: textColor),
                        label: Text("Précédent", style: TextStyle(color: textColor)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size(140, 40),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: quizProvider.currentQuestionIndex < 9
                            ? () {
                                quizProvider.nextQuestion();
                              }
                            : null,
                        label: Text("Suivant", style: TextStyle(color: textColor)),
                        icon: Icon(Icons.arrow_forward, color: textColor),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          minimumSize: const Size(140, 40),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

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
}