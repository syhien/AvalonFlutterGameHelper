import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(const AvalonApp());

class AvalonApp extends StatelessWidget {
  const AvalonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avalon',
      home: const InputPage(),
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.black),
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
            var response = await dio.post('http://127.0.0.1:9876/',
                data: {
                  'PlayersNumber': allPlayersController.text,
                  'GameNumber': gameNumberController.text,
                  'SeatNumber': seatNumberController.text
                },
                options:
                    Options(contentType: Headers.formUrlEncodedContentType));
            Map<String, dynamic> doc = response.data;
            List<int> seenPlayers = doc['seenPlayers'].cast<int>();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IdentityPage(
                        identity: doc['identity'], seenPlayers: seenPlayers)));
          }),
    );
  }
}

class IdentityPage extends StatelessWidget {
  const IdentityPage(
      {Key? key, required this.identity, required this.seenPlayers})
      : super(key: key);

  final String identity;
  final List<int> seenPlayers;

  static const Map<String, String> identitiesChineseMap = {
    'Merlin': '🧙梅林🧙',
    'Percival': '🔍派西维尔🔍',
    'Loyal Servant of Arthur': '⛨亚瑟的忠臣⛨',
    'Morgana': '🎭莫甘娜🎭',
    'Assassin': '🔪刺客🔪',
    'Oberon': '🤪奥伯伦🤪',
    'Minion of Mordred': '👿莫德雷德的爪牙👿',
    'Mordred': '😈莫德雷德😈'
  };

  static const Map<String, Color> identitiesColorMap = {
    'Merlin': Colors.lightBlue,
    'Percival': Colors.lightBlue,
    'Loyal Servant of Arthur': Colors.lightBlue,
    'Morgana': Colors.red,
    'Assassin': Colors.red,
    'Oberon': Colors.red,
    'Minion of Mordred': Colors.red,
    'Mordred': Colors.red,
  };

  static const Map<String, String> identitiesHintMap = {
    'Merlin': ' - 把握场上好恶形势，适时传递必要的信息\n - 谨言慎行，隐藏身份',
    'Percival': ' - 分辨梅林与莫甘娜，接受梅林的讯息并保护梅林不暴露\n - 适时亮明身份并参与任务，提高任务成功的可能性',
    'Loyal Servant of Arthur': ' - 把握场上好恶形势，暗中辨识梅林并听从指引\n - 积极参与任务并掩护梅林身份',
    'Morgana': ' - 模仿梅林欺骗派西维尔以获得信任，尽可能破坏任务\n - 注意场上其他人的言行举止，暗中辨识梅林',
    'Assassin': ' - 积极参与任务并尽可能破坏任务\n - 注意场上其他人的言行举止，暗中辨识梅林',
    'Oberon': ' - 积极参与任务并尽可能破坏任务\n - 注意场上其他人的言行举止，暗中辨识梅林\n - 暗中辨识友方角色并适当地协助他们',
    'Minion of Mordred': ' - 积极参与任务并尽可能破坏任务\n - 注意场上其他人的言行举止，暗中辨识梅林',
    'Mordred': ' - 注意场上其他人的言行举止，暗中辨识梅林\n - 作为“底牌”，在关键时刻破坏任务',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('确认身份'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Text(
                  identitiesChineseMap[identity]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 46, color: identitiesColorMap[identity]),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
                child: Image.asset(
              'images/' + identity + '.jpg',
              width: 350,
            )),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  const Text('你看到了', style: TextStyle(fontSize: 20)),
                  Text(seenPlayers.toString(),
                      style: const TextStyle(fontSize: 40))
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              identitiesHintMap[identity]!,
              style: const TextStyle(fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}
