import 'package:flutter/material.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: const Center(
              child: Text("팀 리스트"),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: const Center(
              child: Text("선수 리스트"),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: const Center(
              child: Text("매칭 기록"),
            ),
          ),
        ),
      ],
    );
  }
}