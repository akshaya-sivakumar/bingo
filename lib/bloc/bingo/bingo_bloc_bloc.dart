import 'dart:convert';

import 'package:bingo/constants.dart';
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
    gamesink();
  }

  void gamestart() {
    on<BingoStartEvent>((event, emit) async {
      emit(bingoDonestate
        ..numberList = event.numberList
        ..start = true);
      channels = IOWebSocketChannel.connect(
          Uri.parse('ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/1'));

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
        if (state.start) {
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
}
