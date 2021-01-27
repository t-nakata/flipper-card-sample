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
      title: 'Flipper Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flipper Card Demo'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[0], cards[1], cards[2], cards[3], cards[4]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[5], cards[6], cards[7], cards[8], cards[9]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[10], cards[11], cards[12], cards[13], cards[14]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[15], cards[16], cards[17], cards[18], cards[19]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[20], cards[21], cards[22], cards[23], cards[24]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [cards[25], cards[26], cards[27], cards[28], cards[29]],
            ),
          ],
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
      do {
        int i1 = Random().nextInt(tempTramps.length);
        int i2 = Random().nextInt(tempTramps.length);
        if (i1 != i2 && getNumber(tempTramps[i1]) == getNumber(tempTramps[i2])) {
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
      tramps.forEach((element) {tempTramps.add(element);});
      tramps.clear();
      do {
        int i = Random().nextInt(tempTramps.length);
        tramps.add(tempTramps[i]);
        tempTramps.removeAt(i);
      } while (tempTramps.length > 0);

    });
  }

  _onTapTramp() {
    print("_onTapTramp()");
    var count = 0;
    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
          count++;
          // print("${tramps[i]}: ${getNumber(tramps[i])}");
        }
      }
    }

    print("count: $count");

    if (count >= 2) {
      if (_isPair()) {
        print("isPair");
        _getCard();
      } else {
        print("closeCard");
        _closeCard();
      }
    }
  }

  bool _isPair() {
    int number = -1;

    for (int i = 0; i < cards.length; i++) {
      if (keys[i] != null && keys[i].currentState != null) {
        if (!keys[i].currentState.isFrontVisible) {
          // print("${tramps[i]}: ${getNumber(tramps[i])}");
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

  _getCard() {
    Future.delayed(Duration(seconds: 1)).then((_) => {
          for (int i = 0; i < cards.length; i++)
            {
              if (keys[i] != null && keys[i].currentState != null)
                {
                  if (!keys[i].currentState.isFrontVisible) {
                      keys[i].currentState.removeCard()
                    }
                }
            }
        });
  }

  _closeCard() {
    Future.delayed(Duration(seconds: 1)).then((_) => {
          for (int i = 0; i < cards.length; i++)
            {
              if (keys[i] != null && keys[i].currentState != null)
                {
                  if (!keys[i].currentState.isFrontVisible)
                    {keys[i].currentState.toggleSide()}
                }
            }
        });
  }
}
