part of 'bingo_game_bloc.dart';

abstract class BingoGameEvent {}

class BingoStartEvent extends BingoGameEvent {
  final List<List<String>> numberList;
  BingoStartEvent(this.numberList);
}

class BingoAddEvent extends BingoGameEvent {
  final String value;

  BingoAddEvent(this.value);
}

class BingoChangeEvent extends BingoGameEvent {
  final String message;

  BingoChangeEvent(this.message);
}
