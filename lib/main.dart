import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/api.dart';
import 'data/mise.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'assets/env/.env');
  // await DotEnv.load(fileName: 'assets/env/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const Center(child: Text('')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          MiseApi api = MiseApi();
          List<Mise> data = await api.getMiseData('중구');
          data.removeWhere((m) => m.pm10 == 0); // clean the data
        },
      ),
    );
  }
}
