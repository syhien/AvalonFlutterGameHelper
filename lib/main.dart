import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';

void main() => runApp(const AvalonApp());

class AvalonApp extends StatelessWidget {
  const AvalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalon',
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final allPlayersController = TextEditingController();
  final gameNumberController = TextEditingController();
  final seatNumberController = TextEditingController();

  @override
  void dispose() {
    allPlayersController.dispose();
    gameNumberController.dispose();
    seatNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('输入游戏信息'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: allPlayersController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: '输入游戏总人数'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: gameNumberController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: '输入本次游戏数字'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: seatNumberController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(), labelText: '输入座位号'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: '获取身份',
          child: const Icon(Icons.games),
          onPressed: () async {
            var dio = Dio();
            var response = await dio.post('http://syh1en.asia/',
                data: {
                  'PlayersNumber': allPlayersController.text,
                  'GameNumber': gameNumberController.text,
                  'SeatNumber': seatNumberController.text
                },
                options:
                    Options(contentType: Headers.formUrlEncodedContentType));
            print(response.data);
          }),
    );
  }
}
