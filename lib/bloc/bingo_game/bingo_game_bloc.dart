import 'dart:convert';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:web_socket_channel/io.dart';
import '../../constants.dart';
import '../../model/bingo_model.dart';
part 'bingo_game_event.dart';
part 'bingo_game_state.dart';

class BingoGameBloc extends Bloc<BingoGameEvent, BingoGameState> {
  BingoChange bingo = BingoChange();
  IOWebSocketChannel? channels;
  BingoGameBloc() : super(BingoGameInitial()) {
    bingoAddEvent();
    bingoChangeEvent();
    bingoStartEvent();
  }

  void bingoStartEvent() async {
    on<BingoStartEvent>(
      (event, emit) async {
        bingo.numberList = event.numberList;
        generateList();
        channels = IOWebSocketChannel.connect(
            Uri.parse('ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/1'));
        emit(bingo
          ..start = true
          ..numberList = event.numberList);
        await emit.onEach(channels!.stream,
            onData: (dynamic message) => add(BingoChangeEvent(message)));
      },
      transformer: restartable(),
    );
  }

  void bingoChangeEvent() {
    on<BingoChangeEvent>((event, emit) {
      emit(BingoProgress());
      BingoModel bingoDetail = BingoModel.fromJson(json.decode(event.message));
      if (bingoDetail.value == "winner") {
        channels?.sink.close();

        emit(bingo
          ..won = true
          ..winnerName = bingoDetail.name);
      } else {
        if (state.start) {
          if (bingoDetail.name == AppConstants.user) {
            bingo.opponentmove = true;
          } else {
            bingo.opponentmove = true;
          }
          bingo.selectedList.add(bingoDetail.value);
          checkBingo();
          emit(bingo);
        }
      }
    });
  }

  void bingoAddEvent() {
    return on<BingoAddEvent>(
      (event, emit) => {
        channels?.sink.add(json
            .encode(BingoModel(name: AppConstants.user, value: event.value))
            .toString())
      },
    );
  }

  List diaList1 = [];
  List diaList2 = [];
  List horiList = [];
  void generateList() {
    horiList = List.generate(5, (index) => List.generate(5, (i) => ""));
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        horiList[i][j] = bingo.numberList[j][i];
      }
    }
    diaList1 = const Matrix2d().diagonal(bingo.numberList);
    diaList2 = const Matrix2d()
        .diagonal(horiList.map((e) => e.reversed.toList()).toList());
  }

  checkBingo() {
    bingo.bingoList = [];
    for (int i = 0; i < 5; i++) {
      if (Set.of(bingo.selectedList).containsAll(bingo.numberList[i])) {
        bingo.bingoList.add(i);
      }
      if (Set.of(bingo.selectedList).containsAll(horiList[i])) {
        bingo.bingoList.add(5 + i);
      }
    }
    if (Set.of(bingo.selectedList).containsAll(diaList1[0])) {
      bingo.bingoList.add(10);
    }
    if (Set.of(bingo.selectedList).containsAll(diaList2[0])) {
      bingo.bingoList.add(11);
    }
    if (bingo.bingoList.length >= 5) {
      channels?.sink.add(json
          .encode(
              BingoModel(name: AppConstants.user, value: "winner".toString()))
          .toString());
    }
  }
}
