import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-6970795657186211/6113194854',
        'android': 'ca-app-pub-6970795657186211/5778121111',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This wihget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Reading Part1',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Mind Reading Part1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  final List<String> _images = <String>[
    'c11.png',
    'c12.png',
    'c13.png',
    'd11.png',
    'd12.png',
    'd13.png',
    'h11.png',
    'h12.png',
    'h13.png',
    's11.png',
    's12.png',
    's13.png',
  ];

  // int _counter = 0;
  List<String> _showCard = <String>[
    'assets/images/h11.png',
    'assets/images/d11.png',
    'assets/images/c11.png',
    'assets/images/s11.png',
    'assets/images/h12.png',
    'assets/images/d12.png'
  ];

  String _instructText1 = '아래의 카드 중 1장의 카드를';
  String _instructText2 = '마음속으로 선택하고 주시하세요.';
  String _fabText = '선택완료';
  bool selectCardPhase = true;
  List<int> selectedCardNum = <int>[0, 0, 0, 0, 0, 0];

  void _runToggleBtn() {
    setState(() {
      if (true == selectCardPhase) {
        _instructText1 = '짠~!';
        _instructText2 = '선택한 카드를 없앴습니다!';
        _fabText = '다시하기';
        _shuffleCards();
        selectCardPhase = false;
      } else {
        _instructText1 = '아래의 카드 중 1장의 카드를';
        _instructText2 = '마음속으로 선택하고 주시하세요.';
        _fabText = '선택완료';
        _initCards();
        selectCardPhase = true;
      }
    });
  }

  @override
  void initState() {
    _initCards();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

/*
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
*/

  /*
  final List<String> _images = <String>[
    'c01.png',
    'c02.png',
    'c03.png',
    'c04.png',
    'c05.png',
    'c06.png',
    'c07.png',
    'c08.png',
    'c09.png',
    'c10.png',
    'c11.png',
    'c12.png',
    'c13.png',
    'd01.png',
    'd02.png',
    'd03.png',
    'd04.png',
    'd05.png',
    'd06.png',
    'd07.png',
    'd08.png',
    'd09.png',
    'd10.png',
    'd11.png',
    'd12.png',
    'd13.png',
    'h01.png',
    'h02.png',
    'h03.png',
    'h04.png',
    'h05.png',
    'h06.png',
    'h07.png',
    'h08.png',
    'h09.png',
    'h10.png',
    'h11.png',
    'h12.png',
    'h13.png',
    's01.png',
    's02.png',
    's03.png',
    's04.png',
    's05.png',
    's06.png',
    's07.png',
    's08.png',
    's09.png',
    's10.png',
    's11.png',
    's12.png',
    's13.png',
  ];
*/

  // 앱 실행시 보여줄 카드 초기화
  void _initCards() {
    playSound('sounds/q.mp3');

    List<int> sixNumbers = [];
    int number = Random().nextInt(_images.length);
    for (int i = 0; i < 6; i++) {
      while (isExistNumber(number, sixNumbers)) {
        number = Random().nextInt(_images.length);
      }
      selectedCardNum[i] = number;
      sixNumbers.add(number);
    }

    for (int num in sixNumbers) {
      debugPrint(num.toString());
    }
    for (int i = 0; i < 6; i++) {
      _showCard[i] = 'assets/images/${_images[sixNumbers[i]]}';
      debugPrint(_showCard[i].toString());
    }
  }

  void playSound(assetPath) async {
    await player.play(AssetSource(assetPath));
  }

  bool isExistNumber(int targetNumber, List<int> fiveNumbers) {
    for (int num in fiveNumbers) {
      if (targetNumber == num) {
        return true;
      }
    }
    return false;
  }

  // 선택완료 후 카드 섞기
  void _shuffleCards() {
    playSound('sounds/a.mp3');

    List<int> sixNumbers = [];
    int number = Random().nextInt(_images.length);
    for (int i = 0; i < 6; i++) {
      while (isExistNumber(number, sixNumbers) || isSelectedNumber(number)) {
        number = Random().nextInt(_images.length);
      }
      sixNumbers.add(number);
    }

    for (int num in sixNumbers) {
      debugPrint(num.toString());
    }
    for (int i = 0; i < 6; i++) {
      _showCard[i] = 'assets/images/${_images[sixNumbers[i]]}';
      debugPrint(_showCard[i].toString());
    }
  }

  bool isSelectedNumber(int targetNumber) {
    for (int num in selectedCardNum) {
      if (targetNumber == num) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Google Admob Start
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: AdRequest(),
    )..load();
    // Google Admob End

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _instructText1,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _instructText2,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _showCard[0],
                  width: 110,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  _showCard[1],
                  width: 110,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  _showCard[2],
                  width: 110,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _showCard[3],
                  width: 110,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  _showCard[4],
                  width: 110,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  _showCard[5],
                  width: 110,
                ),
              ],
            ),
            // Google Admob Start
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Container(
                  width: double.infinity,
                  height: 50,
                  child: AdWidget(
                    ad: banner,
                  ),
                )),
              ],
            ),
            // Google Admob End
            /*
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            */
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _runToggleBtn,
        label: Text(_fabText),
        tooltip: 'Increment',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
