import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final Color buttonColor;
  final String buttonText;
  final Function onPressedButton;

  RoundedButton({@required this.buttonText, this.buttonColor, @required this.onPressedButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressedButton,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
              ),
          ),
        ),
      ),
    );
  }
}
