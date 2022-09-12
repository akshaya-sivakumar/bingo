part of 'bingo_bloc_bloc.dart';

@immutable
abstract class BingoBlocEvent {}

class BingoStartEvent extends BingoBlocEvent {
  final List<List<String>> numberList;

  BingoStartEvent(this.numberList);
}

class BingoStreamEvent extends BingoBlocEvent {
  final String message;

  BingoStreamEvent(this.message);
}

class BingoAddEvent extends BingoBlocEvent {
  final BingoModel bingoData;

  BingoAddEvent(this.bingoData);
}

class BingoCloseEvent extends BingoBlocEvent {
  final String message;

  BingoCloseEvent(this.message);
}

class BingohostEvent extends BingoBlocEvent {
  final String gamecode;

  BingohostEvent(this.gamecode);
}

class BingoAutofillEvent extends BingoBlocEvent {
  final bool autofill;

  BingoAutofillEvent(this.autofill);
}
