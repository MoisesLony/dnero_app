import 'package:flutter/material.dart';

class ShowErrorDialog extends StatelessWidget {
  final String message;
  final String title;
  const ShowErrorDialog({super.key, required this.message, required this.title});

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();

          }, 
          child: Text("Ok"))
      ],
    );
    
  }
    // Helper method to show the dialog
  static void show(BuildContext context, String title,String message) {
    showDialog(
      context: context,
      builder: (context) => ShowErrorDialog(title: title,message: message),
    );
  }
}


