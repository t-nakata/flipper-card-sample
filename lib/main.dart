import 'package:flipper_card_sample/flipper_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'tramp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '一人神経衰弱'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tramp> tramps = [];
  List<FlipperCard> cards = [];
  List<GlobalKey<FlipperCardState>> keys = [];
  int turn = 0;
  int row = 2;
  int col = 4;

  @override
  void initState() {
    super.initState();
    _onTapShuffle();
  }

  @override
  Widget build(BuildContext context) {
    keys.clear();
    cards.clear();
    for (int i = 0; i < tramps.length; i++) {
      GlobalKey<FlipperCardState> key = GlobalKey();
      keys.add(key);
      cards.add(_createFlipperCard(context, tramps[i], key));
    }

    List<Widget> rowList = [];
    var cardCount = 0;
    for (int i = 0; i < row; i++) {
      List<Widget> cardList = [];
      for (int j = 0; j < col; j++) {
        cardList.add(cards[cardCount]);
        cardCount++;
      }
      rowList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cardList,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowList,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTapShuffle(),
        child: Icon(Icons.shuffle),
      ),
    );
  }

  FlipperCard _createFlipperCard(
      BuildContext context, Tramp tramp, GlobalKey key) {

    final cardSize = _calcCardSize(context);
    return FlipperCard(
      key: key,
      frontWidget: Container(
        width: cardSize.width,
        height: cardSize.height,
        alignment: Alignment.center,
        child: Image.asset(getImgPath(Tramp.back)),
      ),
      backWidget: Container(
        width: cardSize.width,
        height: cardSize.height,
        alignment: Alignment.center,
        child: Image.asset(getImgPath(tramp)),
      ),
      onTapTramp: () => _onTapTramp(),
    );
  }

  Size _calcCardSize(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    var width = (size.width - 32) / col;
    var height = (size.height - 100) / row;

    if (width / 409 * 600 < height) {
      // 幅優先
      height = width / 409 * 600;
    } else {
      // 高さ優先
      width = height / 600 * 409;
    }

    return Size(width, height);
  }

  _onTapShuffle() {
    setState(() {
      tramps.clear();

      List<Tramp> tempTramps = [];
      for (int i = 0; i < 54; i++) {
        tempTramps.add(Tramp.values[i]);
      }

      // ランダムでペアを取り出す
      final r = Random();
      do {
        int i1 = r.nextInt(tempTramps.length);
        int i2 = r.nextInt(tempTramps.length);
        if (i1 != i2 &&
            getNumber(tempTramps[i1]) == getNumber(tempTramps[i2])) {
          final tramp1 = tempTramps[i1];
          final tramp2 = tempTramps[i2];
          tramps.add(tramp1);
          tramps.add(tramp2);
          tempTramps.remove(tramp1);
          tempTramps.remove(tramp2);
        }
      } while (tramps.length < row * col);

      // シャッフルする
      tempTramps.clear();
      tramps.forEach((element) {
        tempTramps.add(element);
      });
      tramps.clear();
      do {
        int i = r.nextInt(tempTramps.length);
        tramps.add(tempTramps[i]);
        tempTramps.removeAt(i);
      } while (tempTramps.length > 0);

      turn = 0;
    });
  }

  _onTapTramp() {
    var count = 0;
    for (int i = 0; i < cards.length; i++) {
      if (keys[i].currentState?.isFrontVisible == false) {
        count++;
      }
    }

    if (count >= 2) {
      // タップをブロック
      cards.forEach((element) {
        element.isBlock = true;
      });
      Future.delayed(Duration(seconds: 1), _checkPairAndRemove);
    }
  }

  _checkPairAndRemove() {
    cards.forEach((element) {
      element.isBlock = false;
    });
    if (_isPair()) {
      _removeCard();
    } else {
      _closeCard();
    }
    turn++;
  }

  bool _isPair() {
    int number = -1;
    for (int i = 0; i < cards.length; i++) {
      if (keys[i].currentState?.isFrontVisible == false) {
        if (number == -1) {
          number = getNumber(tramps[i]);
        } else {
          if (number == getNumber(tramps[i])) {
            return true;
          } else {
            return false;
          }
        }
      }
    }
    return false;
  }

  _removeCard() {
    for (int i = 0; i < cards.length; i++) {
      if (keys[i].currentState?.isFrontVisible == false) {
        keys[i].currentState!.removeCard();
      }
    }
    _checkClear();
  }

  _closeCard() {
    for (int i = 0; i < cards.length; i++) {
      if (keys[i].currentState?.isFrontVisible == false) {
        keys[i].currentState!.toggleSide();
      }
    }
  }

  _checkClear() {
    var clear = true;
    keys.forEach((key) {
      if (key.currentState?.isVisible == true) {
        clear = false;
      }
    });

    if (clear) {
      _showClearDialog();
    }
  }

  _showClearDialog() async {
    var value = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ゲームクリア", textAlign: TextAlign.center),
        content: Container(
          height: 240,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$turnターンでクリアできました。\nもう一度プレイしますか？",
                  textAlign: TextAlign.center),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "low"),
                child: Text("初級（3x2)"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "middle"),
                child: Text("中級（4x5)"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "high"),
                child: Text("上級（5x6)"),
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, "CANCEL"),
            child: Text("CANCEL"),
          ),
        ],
      ),
    );

    if (value != "CANCEL") {
      switch (value) {
        case "low":
          col = 4;
          row = 2;
          break;
        case "middle":
          col = 4;
          row = 5;
          break;
        case "high":
          col = 5;
          row = 6;
          break;
      }
      _onTapShuffle();
    }
  }
}
