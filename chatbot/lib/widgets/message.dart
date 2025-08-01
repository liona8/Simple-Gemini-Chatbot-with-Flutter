import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  // Parameters
  final String message;
  final bool isUser;

  // Pass the parameter and trigger some error with initiate some value
  const Message({super.key, this.message = "", this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: //background color
              isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.only(
            // set all the radius by yourself
            topLeft: isUser ? Radius.circular(10) : Radius.circular(0),
            topRight: isUser ? Radius.circular(0) : Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text(message, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
