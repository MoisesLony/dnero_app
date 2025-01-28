import 'dart:convert';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/presentation/providers/categories_provider.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch token state
    final token = ref.watch(tokenProvider);

    // Delay the modification of the provider to avoid the "building widget tree" error
    Future.microtask(() {
      if (token != null) {
        ref.read(categoriesProvider.notifier).fetchCategories(token);
      }
    });

    // Fetch categories state from provider
    final categoryState = ref.watch(categoriesProvider);

  
  

    // Screen size variables
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final Color textColor1 = AppTheme.textPrimaryColor;
    final Color textColor2 = AppTheme.primaryColor;

    // Dynamic opacity calculation
    final dynamicOpacity = (screenWidth / 1000).clamp(0.5, 0.8);

    return Scaffold(
      body: categoryState.when(
        
        loading: () => const Center(
          
          child: CircularProgressIndicator(), // Show loading spinner
        ),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (categories) { 
            // Print the length of the categories
    print('Categories length: ${categories.length}');

    if (categories.isEmpty) {
      return const Center(
        child: Text('No categories available'),
      );
    }
          return SingleChildScrollView(
          child: Column(
            
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.07),
                
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        
                        text: "Elige lo que te ",
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: textColor1,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: "\ngusta",
                        style: TextStyle(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.bold,
                          color: textColor2,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                    ],
                    
                  ),
                  
                ),
                
              ),
              
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (categories.length > 0) 
                CircleCategoryWidget(
                  category: categories[0],
                  size: screenWidth * 0.25, // Tamaño dinámico
                  color: Colors.transparent,
                  textColor: Colors.white,
                    
                ),
                if (categories.length > 1) 
                CircleCategoryWidget(
                  category: categories[1],
                  size: screenWidth * 0.3,
                  color: AppTheme.secondaryColor.withOpacity(dynamicOpacity),
                  textColor: textColor1,
                ),
              ],
            ),
            
            // Segunda fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
              if (categories.length > 2)
                CircleCategoryWidget(
                category: categories[2],
                size: screenWidth * 0.22,
                color: AppTheme.secondaryColor.withOpacity(dynamicOpacity),
                textColor: textColor1,
                ),
              if (categories.length > 3) 
                CircleCategoryWidget(
                  category: categories[3],
                  size: screenWidth * 0.26,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
                if (categories.length > 4) 
                CircleCategoryWidget(
                  category: categories[4],
                  size: screenWidth * 0.23,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
              ],
            ),
            // Tercera fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (categories.length > 5) 
                CircleCategoryWidget(
                  category: categories[5],
                  size: screenWidth * 0.17,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
                if (categories.length > 6) 
                CircleCategoryWidget(
                  category: categories[6],
                  size: screenWidth * 0.21,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
                if (categories.length > 7) 
                CircleCategoryWidget(
                  category: categories[7],
                  size: screenWidth * 0.22,
                  color: AppTheme.secondaryColor.withOpacity(dynamicOpacity),
                  textColor: textColor1,
                ),
                if (categories.length > 8) 
                CircleCategoryWidget(
                  category: categories[8],
                  size: screenWidth * 0.15,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
              ],
            ),
            // Cuarta fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (categories.length > 9) 
                CircleCategoryWidget(
                  category: categories[9],
                  size: screenWidth * 0.27,
                  color: AppTheme.secondaryColor.withOpacity(dynamicOpacity),
                  textColor: textColor1,
                ),
                if (categories.length > 10) 
                CircleCategoryWidget(
                  category: categories[10],
                  size: screenWidth * 0.23,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
                if (categories.length >11) 
                CircleCategoryWidget(
                  category: categories[11],
                  size: screenWidth * 0.2,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
              ],
            ),
            // Última fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (categories.length > 12) 
                CircleCategoryWidget(
                  category: categories[12],
                  size: screenWidth * 0.18,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
                if (categories.length > 13) 
                CircleCategoryWidget(
                  category: categories[13],
                  size: screenWidth * 0.22,
                  color: AppTheme.secondaryColor.withOpacity(dynamicOpacity),
                  textColor: textColor1,
                ),
                if (categories.length > 14) 
                CircleCategoryWidget(
                  category: categories[14],
                  size: screenWidth * 0.2,
                  color: Colors.transparent,
                  textColor: Colors.white
                ),
              ],
            ),
              // Add additional rows for categories
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: () {
                  // Handle next button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.3,
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: Text(
                  "Siguiente",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ),
            ],
          ),
        );
        }
      ),
    );
  }
}

class CircleCategoryWidget extends StatelessWidget {
  final Map<String, String> category;
  final double size;
  final Color color;
  final Color textColor;

  const CircleCategoryWidget({
    Key? key,
    required this.category,
    required this.size,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Handle tap on category
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: MemoryImage(
                    const Base64Decoder().convert(category["image"]!),
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              alignment: Alignment.center,
              child: Text(
                category["name"]!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
