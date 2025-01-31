import 'dart:typed_data';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RecommendationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> recommendation;

  const RecommendationDetailsScreen({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageBytes = recommendation['decodedImage'] as Uint8List?;
    final double rating = (recommendation['calification'] as num?)?.toDouble() ?? 5.0;
    final int roundedRating = rating.floor();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenWidth * 0.08),
                    bottomRight: Radius.circular(screenWidth * 0.08),
                  ),
                  child: imageBytes != null
                      ? Image.memory(imageBytes,
                          height: screenHeight * 0.35, width: double.infinity, fit: BoxFit.cover)
                      : Image.asset("assets/images/default.jpg",
                          height: screenHeight * 0.35, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: screenWidth * 0.05,
                  left: screenWidth * 0.04,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: screenWidth * 0.05,
                  right: screenWidth * 0.04,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            
            // 📍 Title & Location
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation['title'] ?? "No Title",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue, size: screenWidth * 0.06),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        recommendation['location'] ?? "Unknown Location",
                        style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      ...List.generate(
                        roundedRating,
                        (_) => Image.asset('assets/background/icono.png',
                            width: screenWidth * 0.07,
                            height: screenHeight * 0.06,
                            color: Colors.orangeAccent),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            // 📖 About Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
              child: Text(
                "Sobre este lugar:",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
              child: Center(
                child: Text(
                  recommendation['description'] ?? "No Description",
                  style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.black87),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
