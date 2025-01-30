import 'package:flutter/material.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const DrawerWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Use Container instead of DrawerHeader to remove extra padding
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(20), // Adjust padding as needed
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ✅ Remove divider effect by adjusting ListTile padding
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppTheme.primaryColor),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppTheme.textPrimaryColor),
              ),
              visualDensity: VisualDensity.compact, // Reduces extra space
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Adjusts spacing
              onTap: onLogout, // Calls the logout function
            ),
          ),
        ],
      ),
    );
  }
}
