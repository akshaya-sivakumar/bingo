part of 'bingo_game_bloc.dart';

class BingoGameState {
  List<List<String>> numberList =
      List.generate(5, (index) => List.generate(5, (i) => ""));
  List selectedList = [];
  List bingoList = [];
  bool start = false;
  bool won = false;
  String winnerName = "";
}

class BingoGameInitial extends BingoGameState {}

// ignore: must_be_immutable
class BingoChange extends BingoGameState {}

class BingoProgress extends BingoGameState {}
