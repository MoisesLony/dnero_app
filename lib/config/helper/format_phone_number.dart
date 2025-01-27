
import 'package:flutter/services.dart';

class FormatPhoneNumber extends TextInputFormatter{
  
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue){
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length >8){
      digits = digits.substring(0,8);
    }
    String formatted = '';
    if(digits.length <=4){
      formatted = digits;
    } else{
      formatted = '${digits.substring(0,4)}-${digits.substring(4)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length)
    );
  }
  
}