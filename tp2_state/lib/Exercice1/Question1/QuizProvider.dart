import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  List<String?> answers = List.filled(10, null);

  void setQuestions(List<dynamic> newQuestions) {
    questions = newQuestions;
    notifyListeners();
  }

  void submitAnswer(bool userChoice) {
    answers[currentQuestionIndex] = userChoice ? "Vrai" : "Faux";
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      notifyListeners();
    }
  }

  bool allQuestionsAnswered() {
    return answers.every((a) => a != null);
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < answers.length; i++) {
      if ((answers[i] == "Vrai" && questions[i]['isCorrect'] == true) ||
          (answers[i] == "Faux" && questions[i]['isCorrect'] == false)) {
        score++;
      }
    }
    return score;
  }
}