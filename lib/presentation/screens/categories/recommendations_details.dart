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
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: imageBytes != null
                      ? Image.memory(imageBytes, height: 280, width: double.infinity, fit: BoxFit.cover)
                      : Image.asset("assets/images/default.jpg", height: 280, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 15,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recommendation['title'] ?? "No Title",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppTheme.textPrimaryColor,fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text(
                        recommendation['location'] ?? "Unknown Location",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(
                        roundedRating,
                        (_) => Image.asset('assets/background/icono.png', width: 25, height: 22,color: Colors.orangeAccent,)), 
                      const SizedBox(width: 5),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            // 📖 About Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical:0),
              child: Text(
                "Sobre este lugar:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppTheme.primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  recommendation['description'] ?? "No Description",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
