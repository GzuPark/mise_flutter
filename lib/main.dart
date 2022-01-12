import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/api.dart';
import 'data/mise.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();

  await dotenv.load(fileName: 'assets/env/.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> colors = [
    const Color(0xFF0077c2),
    const Color(0xFF009ba9),
    const Color(0xFFfe6300),
    const Color(0xFFd80019),
  ];

  List<String> icon = [
    'assets/img/happy.png',
    'assets/img/normal.png',
    'assets/img/bad.png',
    'assets/img/angry.png',
  ];

  List<String> status = ['좋음', '보통', '나쁨', '매우나쁨'];
  String stationName = '중구';
  List<Mise> data = [];

  int getStatus(Mise mise) {
    if (mise.pm10! > 150) {
      return 3;
    } else if (mise.pm10! > 80) {
      return 2;
    } else if (mise.pm10! > 30) {
      return 1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String l = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const LocationPage()));
          stationName = l;
          getData();
        },
        child: const Icon(Icons.location_on),
      ),
    );
  }

  Widget getPage() {
    if (data.isEmpty) {
      return Container();
    }

    int _status = getStatus(data.first);

    return Container(
      color: colors[_status],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 60),
          const Text(
            '현재 위치',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(height: 12),
          Text(
            '[$stationName]',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Container(height: 60),
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(icon[_status], fit: BoxFit.contain),
          ),
          Container(height: 60),
          Text(
            status[_status],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(height: 20),
          Text(
            '통합 환경 대기 지수 : ${data.first.khai}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          Expanded(
            child: SizedBox(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  data.length,
                  (idx) {
                    Mise mise = data[idx];
                    int _status = getStatus(mise);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            mise.dataTime.toString().replaceAll(' ', '\n'),
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Container(height: 8),
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(icon[_status], fit: BoxFit.contain),
                          ),
                          Container(height: 8),
                          Text('${mise.pm10}ug/m2', style: const TextStyle(fontSize: 10, color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          AdmobBanner(
            adUnitId: AdmobBanner.testAdUnitId,
            // adUnitId: dotenv.env['AD_UNIT_ID'].toString(),
            adSize: AdmobBannerSize.BANNER,
          ),
          Container(height: 100),
        ],
      ),
    );
  }

  void getData() async {
    MiseApi api = MiseApi();
    data = await api.getMiseData(stationName);
    data.removeWhere((m) => m.pm10 == 0); // clean the data
    setState(() {});
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    '강남구',
    '강동구',
    '강북구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '송파구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중랑구',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: List.generate(
          locations.length,
          (idx) {
            return ListTile(
              title: Text(locations[idx]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop(locations[idx]);
              },
            );
          },
        ),
      ),
    );
  }
}
