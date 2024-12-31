abstract class QuizEvent {}

class GoToQuestion extends QuizEvent {
  final int questionIndex;
  GoToQuestion(this.questionIndex);
}

class LoadQuestions extends QuizEvent {
  final Map<String, dynamic> theme;
  LoadQuestions(this.theme);
}

class SubmitAnswer extends QuizEvent {
  final bool userChoice;
  SubmitAnswer(this.userChoice);
}

class NextQuestion extends QuizEvent {}

class PreviousQuestion extends QuizEvent {}