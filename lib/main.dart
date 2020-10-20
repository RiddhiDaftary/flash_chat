import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: Firebase.initializeApp(),
      builder: (context,snapshot){
        return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          bodyText2: TextStyle(color: Colors.black54),
//        ),
//      ),
          initialRoute: WelcomeScreen.id,
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            WelcomeScreen.id: (context) => WelcomeScreen(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            LoginScreen.id: (context) => LoginScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
          },
        );
      },
    );
  }
}
