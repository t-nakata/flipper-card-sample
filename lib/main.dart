import 'package:flipper_card_sample/flipper_card.dart';
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
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Tramp> tramps = [];
  List<FlipperCard> cards = [];
  List<GlobalKey<FlipperCardState>> keys = [];

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
    for (int i = 0; i < 6; i++) {
      List<Widget> cardList = [];
      for (int j = 0; j < 5; j++) {
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

  Widget _createFlipperCard(BuildContext context, Tramp tramp, GlobalKey key) {
    final Size size = MediaQuery.of(context).size;
    final width = size.width / 4 - 32;
    final height = width / 409 * 600;

    return FlipperCard(
      key: key,
      frontWidget: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Image.asset(getImgPath(Tramp.back)),
      ),
      backWidget: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Image.asset(getImgPath(tramp)),
      ),
      onTapTramp: () => _onTapTramp(),
    );
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
      } while (tramps.length < 30);

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

    });
  }

  _onTapTramp() {
    var count = 0;
    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
          count++;
        }
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
  }

  bool _isPair() {
    int number = -1;
    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
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
    }
    return false;
  }

  _removeCard() {
    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
          keys[i].currentState.removeCard();
        }
      }
    }
    _checkClear();
  }

  _closeCard() {
    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
          keys[i].currentState.toggleSide();
        }
      }
    }
  }

  _checkClear() {
    var clear = true;
    keys.forEach((key) {
      if (key != null && key.currentState!= null && key.currentState.isVisible) {
        clear = false;
      }
    });

    if (clear) {
      _showClearDialog();
    }
  }

  _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ゲームクリア", textAlign: TextAlign.center),
        content: Text("もう一度プレイしますか？", textAlign: TextAlign.center),
        actions:[
          FlatButton(
            onPressed: () => Navigator.pop(context, "CANCEL"),
            child: Text("CANCEL"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, "OK"),
            child: Text("OK"),
          ),
        ],
      ),
    ).then((value) => {
      if (value == "OK") {
        _onTapShuffle()
      }
    });
  }
}
