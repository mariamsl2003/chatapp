import 'package:chatapp/Model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timeStamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timeStamp: timeStamp);

    //construct chat room id from current user id and reciver id(to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //ensure the chat room ids is the same to both sides
    String chatRoomId = ids
        .join("_"); //combine the ids into single string to use as chat room id

    //add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserID) {
    //construct the chat room id from the users ids
    List<String> ids = [userId, otherUserID];
    ids.sort();
    final String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }
}
