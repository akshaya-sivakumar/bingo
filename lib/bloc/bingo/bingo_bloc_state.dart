part of 'bingo_bloc_bloc.dart';

@immutable
abstract class BingoBlocState {
  List<List<String>> numberList =
      List.generate(5, (index) => List.generate(5, (i) => ""));
  List selectedList = [];
  List bingoList = [];
  bool start = false;
  bool won = false;
  String? winnerName;
  bool opponentMove = false;
}

class BingoBlocInitial extends BingoBlocState {}

class BingoProgressstate extends BingoBlocState {}

class BingoDonestate extends BingoBlocState {}
