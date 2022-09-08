import 'package:bingo/bloc/bingo_game/bingo_game_bloc.dart';
import 'package:bingo/ui/widgets/bingo_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_utils.dart';
import '../widgets/bingo_name_widget.dart';
import '../widgets/boxcell.dart';
import '../widgets/winner_widget.dart';

class BingoGamePage extends StatefulWidget {
  const BingoGamePage({super.key});

  @override
  State<BingoGamePage> createState() => _BingoGamePageState();
}

class _BingoGamePageState extends State<BingoGamePage> {
  int number = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BingoScaffold(child: BlocBuilder<BingoGameBloc, BingoGameState>(
      builder: (context, state) {
        if (state is BingoProgress) return Container();
        if (state.won) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WinnerDialog.hostDialog(context, state.winnerName);
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/bingo_name.png"),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(50)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(50)),
                    child: Table(
                      border: TableBorder.all(color: Colors.white),
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                        2: IntrinsicColumnWidth(),
                        3: IntrinsicColumnWidth(),
                        4: IntrinsicColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        for (int i = 0; i < 5; i++)
                          TableRow(
                            children: <Widget>[
                              for (int j = 0; j < 5; j++)
                                IgnorePointer(
                                  ignoring: state.start == true
                                      ? false
                                      : state.numberList[i][j] != "",
                                  child: InkWell(
                                    onTap: () {
                                      if (state.start == true &&
                                          !state.selectedList.contains(
                                              state.numberList[i][j])) {
                                        BlocProvider.of<BingoGameBloc>(context)
                                            .add(BingoAddEvent(
                                                state.numberList[i][j]));
                                      } else if (state.start == false) {
                                        setState(() {
                                          number += 1;
                                          state.numberList[i][j] =
                                              number.toString();
                                        });
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        BoxCell(number: state.numberList[i][j]),
                                        if (state.selectedList.contains(
                                                state.numberList[i][j]) &&
                                            state.numberList[i][j] != "")
                                          const Icon(
                                            Icons.close,
                                            size: 55,
                                            color: Colors.deepPurple,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  for (var data in state.bingoList) AppUtils.bingoStrike(data),
                ],
              ),
            ),
            Bingo(state.bingoList.length),
            if (!state.numberList.expand((element) => element).contains(""))
            AppUtils.start(context, state.numberList),
            AppUtils.quit(context)
          ],
        );
      },
    ));
  }
}
