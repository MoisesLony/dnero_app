import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class OtpWidget extends StatelessWidget {
  final double scalingFactor;
  final String lastFourDigits;
  final Color textColor;
  final Color textColor2;
  final String text;

  const OtpWidget({
    Key? key,
    required this.scalingFactor,
    required this.lastFourDigits,
    required this.textColor,
    required this.textColor2,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scalingFactor), // Add some padding
      child: FadeIn(
        duration: const Duration(seconds: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 22 * scalingFactor,
                color: textColor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5 * scalingFactor), // Add spacing
            Text(
              'Escribe el código enviado a',
              style: TextStyle(
                fontSize: 22 * scalingFactor,
                color: textColor,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              'xxxx-$lastFourDigits', // Display the last 4 digits
              style: TextStyle(
                fontSize: 22 * scalingFactor,
                color: textColor2,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
