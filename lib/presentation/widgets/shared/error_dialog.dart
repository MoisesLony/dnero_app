import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ShowErrorDialog extends StatelessWidget {
  final String message;
  final String title;
  const ShowErrorDialog({super.key, required this.message, required this.title});

  @override

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(title,style: const TextStyle(
          color: AppTheme.textPrimaryColor,
          fontFamily: 'Poppins',
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
      ),
      content: 

      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(message,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontFamily: 'Poppins',
          ),
          ),
      ),
    
      actions: [
        const Divider(),
        Center(
          child: TextButton(
            onPressed: (){
              Navigator.of(context).pop();
          
            }, 
            child: const Text("Descartar",
              style:  TextStyle(
                color: AppTheme.textPrimaryColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                
              ),
              )),
        )
      ],
    );
    
  }
    // Helper method to show the dialog
  static void show(BuildContext context, String title,String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ShowErrorDialog(title: title,message: message),
    );
  }
}


