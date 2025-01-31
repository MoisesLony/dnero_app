import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scalingFactor = size.height / 812; // Base height for scaling
    final double widthFactor = size.width / 375; // Base width for scaling

    const Color customTextPrimaryColor = AppTheme.textPrimaryColor;
    const Color backgroundColor = AppTheme.primaryColor;
    const Color buttonColor = AppTheme.secondaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16 * widthFactor),
                child: SizedBox(
                  width: 300 * widthFactor,
                  height: 54 * scalingFactor,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20 * scalingFactor),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        fontSize: 19 * scalingFactor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: customTextPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16 * scalingFactor),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿No tienes cuenta? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20 * scalingFactor,
                    fontFamily: 'Poppins',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push("/register");
                  },
                  child: Text(
                    "Regístrate",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 125, 252, 146),
                      fontSize: 20 * scalingFactor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 60 * scalingFactor),
          ],
        ),
      ),
    );
  }
}
