import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
auth.User loggedinUser;


class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageTextController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;

  String messageText;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedinUser.email,
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          );
        }
        final messages = snapshot.data.docs.reversed;

        List<ChatBubble> cahtBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final chatBubble = ChatBubble(
              sender: messageSender,
              text: messageText,
            isMe: loggedinUser.email == messageSender,
          );
          cahtBubbles.add(chatBubble);

        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: cahtBubbles,
          ),
        );
      },
    );
  }
}


class ChatBubble extends StatelessWidget {

  final String sender;
  final String text;
  final bool isMe;

  ChatBubble({this.sender,this.text,this.isMe});

  Color getBubbleColor(){
    return isMe?Colors.lightBlueAccent:Colors.white;
  }

  Color getBubbleTextColor(){
    return isMe?Colors.white:Colors.black54;
  }

  CrossAxisAlignment getChatAlignment(){
    return isMe? CrossAxisAlignment.end:CrossAxisAlignment.start;
  }

  BorderRadius getBubbleBorderRadius(){
    return isMe? BorderRadius.only(
      topLeft: Radius.circular(15.0),
      topRight: Radius.circular(0.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0),
    ): BorderRadius.only(
        topLeft: Radius.circular(0.0),
    topRight: Radius.circular(15.0),
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0));
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: getChatAlignment(),
        children: [
          Text(
              sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: getBubbleBorderRadius(),
            elevation: 5.0,
            color: getBubbleColor(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              child: Text(
                  text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: getBubbleTextColor(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
