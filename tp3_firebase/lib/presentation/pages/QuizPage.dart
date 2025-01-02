import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ResultPage.dart';
import '../../data/providers/ThemeProvider.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> theme;

  const QuizPage({super.key, required this.theme});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<dynamic> questions;
  int currentQuestionIndex = 0;
  List<String?> answers = [];
  String? imageUrl;
  AudioPlayer audioPlayer = AudioPlayer();
  String? winSoundUrl;
  String? loseSoundUrl;

  @override
  void initState() {
    super.initState();
    questions = _getRandomQuestions(widget.theme['questions']);
    answers = List.filled(min(10, questions.length), null);
    _loadImage();
    _loadSounds();
  }

  Future<void> _loadImage() async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/${widget.theme['theme']}.png');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      final ref = FirebaseStorage.instance.ref().child('images/quizz.png');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    }
  }

  Future<void> _loadSounds() async {
    try {
      final winRef = FirebaseStorage.instance.ref().child('audio/win.wav');
      final loseRef = FirebaseStorage.instance.ref().child('audio/lose.wav');
      final winUrl = await winRef.getDownloadURL();
      final loseUrl = await loseRef.getDownloadURL();
      setState(() {
        winSoundUrl = winUrl;
        loseSoundUrl = loseUrl;
      });
    } catch (e) {
      // Handle errors
    }
  }

  List<dynamic> _getRandomQuestions(List<dynamic> allQuestions) {
    final random = Random();
    final List<dynamic> selectedQuestions = [];
    while (selectedQuestions.length < min(10, allQuestions.length)) {
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
            builder: (context) => ResultPage(score: score, totalQuestions: questions.length),
          ),
        );
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
          }
        });
      });
    }

    _playSound(userChoice == questions[currentQuestionIndex]['isCorrect']);
  }

  Future<void> _playSound(bool isCorrect) async {
    if (isCorrect && winSoundUrl != null) {
      await audioPlayer.play(UrlSource(winSoundUrl!));
    } else if (!isCorrect && loseSoundUrl != null) {
      await audioPlayer.play(UrlSource(loseSoundUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    final currentQuestion = questions[currentQuestionIndex];
    final userAnswer = answers[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.theme['theme']}"),
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
              if (imageUrl != null)
                Image.network(
                  imageUrl!,
                  height: 150,
                  fit: BoxFit.cover,
                )
              else
                CircularProgressIndicator(),
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
                        side: userAnswer == null ? const BorderSide(color: Colors.green) : BorderSide.none,
                      ),
                      onPressed: userAnswer == null ? () => _submitAnswer(true) : () {},
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
                        side: userAnswer == null ? const BorderSide(color: Colors.green) : BorderSide.none,
                      ),
                      onPressed: userAnswer == null ? () => _submitAnswer(false) : () {},
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
                              : answers[index] == "Vrai" && questions[index]['isCorrect'] == true
                                  ? Colors.green
                                  : answers[index] == "Faux" && questions[index]['isCorrect'] == false
                                      ? Colors.green
                                      : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: index == currentQuestionIndex ? Border.all(color: textColor, width: 2) : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: index == currentQuestionIndex
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
                    onPressed: currentQuestionIndex > 0
                        ? () {
                            setState(() {
                              currentQuestionIndex--;
                            });
                          }
                        : null,
                    icon: Icon(Icons.arrow_back, color: textColor),
                    label: Text("Précédent", style: TextStyle(color: textColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(140, 40),
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
                    label: Text("Suivant", style: TextStyle(color: textColor)),
                    icon: Icon(Icons.arrow_forward, color: textColor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(140, 40),
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