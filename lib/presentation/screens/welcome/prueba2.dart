import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/presentation/providers/categories_provider.dart';
import 'package:dnero_app_prueba/presentation/providers/selected_categories_provider.dart';

class CategorySelectionScreen2 extends ConsumerStatefulWidget {
  const CategorySelectionScreen2({Key? key}) : super(key: key);

  @override
  _CategorySelectionScreen2State createState() => _CategorySelectionScreen2State();
}

class _CategorySelectionScreen2State extends ConsumerState<CategorySelectionScreen2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token =  "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjcwODgzMDYyIiwiaWF0IjoxNzM4MDg2MDUxLCJleHAiOjE3MzgxNjg4NTF9.MJSpprO9nqXP_QC_xgOxGhyf10xASbL8Vs21H-kS6NGs4KsF96_QZ-on5U63-7NXFiz5p4YxYyt1iAYlH5OZtg62bnSzKG0XZhTqNVxQIcBZZH9n8CfJC6Rng-PZEsQWPHgkRFmWfp8ReDyjdaRypn4-94lt987QfmiSwZbmRDnQSobLzLCME44xNvw-tL-EJUKvI3Opo047rV5ZEutf4ow0CQGUqdqJP6ZzO3WA853Rqq0sfoECW3S1LxzTiwbO7osXpNeB4EqUOx9I1WR7RqDgGq71La4W9PiA1sfpDJnOP7zDin75whsPR8AMuLh9sjmsko-A2uNqZJsM5S-R8Q";

      ref.read(categoriesProvider.notifier).fetchCategories(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoriesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: categoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.07),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Elige lo que te ",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: "gusta",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (var rowCategories in _chunk(categories, 3)) // Organiza en filas de 3 elementos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: rowCategories.map((category) {
                          return _CategoryItem(category: category, screenWidth: screenWidth);
                        }).toList(),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: SizedBox(
                  width: screenWidth * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: ref.read(selectedCategoriesProvider).isNotEmpty
                        ? () {
                            print("Selected Categories IDs: ${ref.read(selectedCategoriesProvider)}");
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Agrupa categorías en filas de `n` elementos
  List<List<Map<String, dynamic>>> _chunk(List<Map<String, dynamic>> list, int chunkSize) {
    List<List<Map<String, dynamic>>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }
}

class _CategoryItem extends StatelessWidget {
  final Map<String, dynamic> category;
  final double screenWidth;

  const _CategoryItem({
    Key? key,
    required this.category,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("🔄 Rebuilding CategoryItem: ${category["name"]}");

    return Consumer(
      builder: (context, ref, _) {
        final selectedCategories = ref.watch(selectedCategoriesProvider);
        final bool isSelected = selectedCategories.contains(category["id"]);

        return GestureDetector(
          onTap: () {
            ref.read(selectedCategoriesProvider.notifier).toggleCategory(category["id"]!);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: screenWidth * 0.22,
                height: screenWidth * 0.22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: MemoryImage(
                      base64Decode(category["image"] ?? ''),
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
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 0.7 : 0.4,
                child: Container(
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.green : Colors.black,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category["name"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.purple : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
