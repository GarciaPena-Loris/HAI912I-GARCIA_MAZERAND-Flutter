import 'dart:math';
import 'package:bloc/bloc.dart';
import '../events/QuizEvent.dart';
import '../states/QuizState.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<LoadQuestions>(_onLoadQuestions);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<GoToQuestion>(_onGoToQuestion); // Add this line to register the event handler
  }

  void _onLoadQuestions(LoadQuestions event, Emitter<QuizState> emit) {
    emit(QuizLoading());
    final questions = event.theme['questions'];
    if (questions == null || questions.isEmpty) {
      emit(QuizInitial()); // or handle the error appropriately
    } else {
      final selectedQuestions = _getRandomQuestions(questions);
      emit(QuizLoaded(selectedQuestions, 0, List.filled(10, null)));
    }
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final answers = List<String?>.from(currentState.answers);
      answers[currentState.currentQuestionIndex] = event.userChoice ? "Vrai" : "Faux";

      if (answers.every((a) => a != null)) {
        int score = 0;
        for (int i = 0; i < answers.length; i++) {
          if ((answers[i] == "Vrai" && currentState.questions[i]['isCorrect'] == true) ||
              (answers[i] == "Faux" && currentState.questions[i]['isCorrect'] == false)) {
            score++;
          }
        }
        emit(QuizCompleted(score));
      } else {
        emit(QuizLoaded(currentState.questions, currentState.currentQuestionIndex, answers));
        await Future.delayed(const Duration(seconds: 1));
        emit(QuizLoaded(currentState.questions, currentState.currentQuestionIndex + 1, answers));
      }
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
        emit(QuizLoaded(currentState.questions, currentState.currentQuestionIndex + 1, currentState.answers));
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex > 0) {
        emit(QuizLoaded(currentState.questions, currentState.currentQuestionIndex - 1, currentState.answers));
      }
    }
  }

  void _onGoToQuestion(GoToQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      emit(QuizLoaded(currentState.questions, event.questionIndex, currentState.answers));
    }
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