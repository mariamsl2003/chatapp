import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //send message when there is something to send
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.recivedUserUID, _messageController.text);
    }
    //clear the message after sending
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recivedUserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),

          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessages(
            widget.recivedUserUID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to left if the sender is current user otherwise to the right
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(
              height: 5,
            ),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'enter message',
              obscureText: false,
            ),
          ),

          //send buttom
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
