import 'dart:convert';
import 'dart:math';

import 'package:async/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bingo/constants.dart';
import 'package:bingo/ui/screens/generate_code.dart';
import 'package:bingo/ui/screens/join_game.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix2d/matrix2d.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/bingo_model.dart';
import '../../ui/screens/bingo.dart';

part 'bingo_bloc_event.dart';
part 'bingo_bloc_state.dart';

class BingoBlocBloc extends Bloc<BingoBlocEvent, BingoBlocState> {
  IOWebSocketChannel? channels;
  BingoDonestate bingoDonestate = BingoDonestate();
  BingoBlocBloc() : super(BingoBlocInitial()) {
    gameHost();
    gamestart();
    gamestream();

    autofill();

    gamesink();

    // gameClose();
  }

  void gamestart() {
    on<BingoStartEvent>((event, emit) async {
      emit(BingoProgressstate());
      emit(bingoDonestate
        ..numberList = event.numberList
        ..start = true
        ..opponentMove = CodePage.type == "join");
      channels?.sink.close();
      channels = IOWebSocketChannel.connect(Uri.parse(
          'ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/${JoinGame.gamecode}/${CodePage.type}/2'));
      if (kDebugMode) {
        print("connected ${JoinGame.gamecode} ${CodePage.type}");
      }
      generateList();
      await emit.onEach(channels!.stream, onData: (message) {
        if (kDebugMode) {
          print(message);
        }
        if (MyHomePage.musicPlay) {
          AudioPlayer().play(
            AssetSource('audio/tone.mp3'),
          );
        }
        add(BingoStreamEvent(message.toString()));
      });
    }, transformer: sequential());
  }

  void gameHost() {
    on<BingohostEvent>((event, emit) async {
      channels = IOWebSocketChannel.connect(Uri.parse(
          'ws://bingo-api-vxbrwrpk5q-el.a.run.app/ws/${event.gamecode}/${CodePage.type}/2'));
      if (kDebugMode) {
        print("connected ${event.gamecode} ${CodePage.type}");
      }

      if (CodePage.type == "join") {
        channels?.sink.add(json
            .encode(BingoModel(name: AppConstants.user, value: "Joined"))
            .toString());
      }

      await emit.onEach(channels!.stream, onData: (message) {
        if (kDebugMode) {
          print("streaming");
        }
        if (MyHomePage.musicPlay) {
          AudioPlayer().play(
            AssetSource('audio/tone.mp3'),
          );
        }
        add(BingoStreamEvent(message.toString()));
      });
    }, transformer: sequential());
  }

  CancelableOperation? dataStreaming;

  void gamestream() {
    on<BingoStreamEvent>((event, emit) async {
      emit(BingoProgressstate());
      if (kDebugMode) {
        // print(event.message);
      }
      BingoModel bingoDetail = BingoModel.fromJson(json.decode(event.message));
      if (bingoDetail.value == "Joined") {
        if (CodePage.type == "host") {
          bingoDonestate.userJoined = true;
          emit(bingoDonestate);
        } else {
          emit(bingoDonestate);
        }
      } else if (bingoDetail.value == "Exit") {
        if (bingoDetail.name == AppConstants.user) {
          emit(BingoClosestate(false, bingoDetail.name));
        } else {
          emit(BingoClosestate(true, bingoDetail.name));
        }
      } else if (bingoDetail.value == "winner") {
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
          print(bingoDonestate.opponentMove);
          bingoDonestate.selectedList.add(bingoDetail.value);

          checkBingo();
          emit(bingoDonestate);
        }
      }
    });
  }

  /*  void gameClose() {
    on<BingoCloseEvent>((event, emit) async {
      channels?.sink.close();
      emit(BingoClosestate());
    });
  } */

  void autofill() {
    on<BingoAutofillEvent>((event, emit) async {
      emit(BingoProgressstate());
      if (kDebugMode) {
        print(event.autofill);
      }
      if (event.autofill) {
        autoGenerate();
        emit(bingoDonestate..numberList = state.numberList);
      } else {
        emit(BingoBlocInitial());
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

  autoGenerate() {
    List list = shuffle(List<int>.generate(25, (i) => i + 1));

    int number = 0;

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        state.numberList[i][j] = list[number].toString();
        number += 1;
      }
    }
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

  @override
  Future<void> close() async {
    channels?.sink.close();
    super.close();
  }
}
