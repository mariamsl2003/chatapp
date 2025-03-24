import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recivedUserEmail;
  final String recivedUserUID;
  const ChatPage(
      {super.key,
      required this.recivedUserEmail,
      required this.recivedUserUID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recivedUserEmail),
      ),
    );
  }
}
