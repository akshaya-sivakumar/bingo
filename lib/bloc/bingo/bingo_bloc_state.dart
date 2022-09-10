part of 'bingo_bloc_bloc.dart';

@immutable
// ignore: must_be_immutable
abstract class BingoBlocState {
  List<List<String>> numberList =
      List.generate(5, (index) => List.generate(5, (i) => ""));
  List selectedList = [];
  List bingoList = [];
  bool start = false;
  bool won = false;
  String? winnerName;
  bool opponentMove = false;
  bool userJoined = false;
}

// ignore: must_be_immutable
class BingoBlocInitial extends BingoBlocState {}

// ignore: must_be_immutable
class BingoProgressstate extends BingoBlocState {}

// ignore: must_be_immutable
class BingoDonestate extends BingoBlocState {}

// ignore: must_be_immutable
class BingoClosestate extends BingoBlocState {
  final bool opponentLeft;
  final String username;

  BingoClosestate(this.opponentLeft, this.username);
}
