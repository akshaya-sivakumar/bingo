import 'dart:convert';
import 'dart:math';

import 'package:bingo/constants.dart';
import 'package:bingo/ui/screens/join_game.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/bingo_model.dart';

part 'bingo_bloc_event.dart';
part 'bingo_bloc_state.dart';

class BingoBlocBloc extends Bloc<BingoBlocEvent, BingoBlocState> {
  IOWebSocketChannel? channels;
  BingoDonestate bingoDonestate = BingoDonestate();
  BingoBlocBloc() : super(BingoBlocInitial()) {
    gamestart();
    gamestream();

    autoGenerate();

    gamesink();
    gameClose();
  }

  void gamestart() {
    on<BingoStartEvent>((event, emit) async {
      emit(bingoDonestate
        ..numberList = event.numberList
        ..start = true);
      channels = IOWebSocketChannel.connect(Uri.parse(
          'ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/${JoinGame.gamecode}'));

      generateList();
      await emit.onEach(channels!.stream,
          onData: (message) => add(BingoStreamEvent(message.toString())));
    }, transformer: restartable());
  }

  void gamestream() {
    on<BingoStreamEvent>((event, emit) async {
      emit(BingoProgressstate());
      if (kDebugMode) {
        print(event.message);
      }
      BingoModel bingoDetail = BingoModel.fromJson(json.decode(event.message));
      if (bingoDetail.value == "winner") {
        channels?.sink.close();
        if (kDebugMode) {
          print(bingoDetail.value);
        }
        emit(bingoDonestate
          ..won = true
          ..winnerName = bingoDetail.name);
      } else {
        if (bingoDonestate.start) {
          if (bingoDetail.name == AppConstants.user) {
            bingoDonestate.opponentMove = true;
          } else {
            bingoDonestate.opponentMove = false;
          }
          bingoDonestate.selectedList.add(bingoDetail.value);

          checkBingo();
          emit(bingoDonestate);
        }
      }
    });
  }

  void gameClose() {
    on<BingoCloseEvent>((event, emit) async {
      channels?.sink.close();
      emit(BingoClosestate());
    });
  }

  void gamesink() {
    on<BingoAddEvent>((event, emit) async {
      channels?.sink.add(json.encode(event.bingoData).toString());
    });
  }

  List diaList1 = [];
  List diaList2 = [];
  List horiList = [];

  void generateList() {
    horiList = List.generate(5, (index) => List.generate(5, (i) => ""));
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        horiList[i][j] = bingoDonestate.numberList[j][i];
      }
    }
    diaList1 = const Matrix2d().diagonal(bingoDonestate.numberList);
    diaList2 = const Matrix2d()
        .diagonal(horiList.map((e) => e.reversed.toList()).toList());
  }

  checkBingo() {
    bingoDonestate.bingoList = [];

    //-----horizontal and ver list
    for (int i = 0; i < 5; i++) {
      if (Set.of(bingoDonestate.selectedList)
          .containsAll(bingoDonestate.numberList[i])) {
        bingoDonestate.bingoList.add(i);
      }
      if (Set.of(bingoDonestate.selectedList).containsAll(horiList[i])) {
        bingoDonestate.bingoList.add(5 + i);
      }
    }

    //-----diagonal

    if (Set.of(bingoDonestate.selectedList).containsAll(diaList1[0])) {
      bingoDonestate.bingoList.add(10);
    }
    if (Set.of(bingoDonestate.selectedList).containsAll(diaList2[0])) {
      bingoDonestate.bingoList.add(11);
    }
    if (kDebugMode) {
      print("state.bingolist${state.bingoList}");
    }

    if (bingoDonestate.bingoList.length >= 5) {
      channels?.sink.add(json
          .encode(
              BingoModel(name: AppConstants.user, value: "winner".toString()))
          .toString());
    }
  }

  autoGenerate() {
    List list = shuffle(List<int>.generate(25, (i) => i + 1));

    int number = 0;

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        state.numberList[i][j] = list[number].toString();
        number += 1;
      }
    }
    print(state.numberList);
  }

  List shuffle(List array) {
    var random = Random(); //import 'dart:math';

    // Go through all elementsof list
    for (var i = array.length - 1; i > 0; i--) {
      // Pick a random number according to the lenght of list
      var n = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
    return array;
  }
}
