import 'dart:convert';
import 'dart:typed_data';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';
import 'package:dnero_app_prueba/presentation/widgets/category_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends ConsumerState<CategorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Fetch categories when the screen initializes
      final token = ref.watch(tokenProvider);
      ref.read(categoriesProvider.notifier).fetchCategories(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch category provider state
    final categoryState = ref.watch(categoriesProvider);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTitle(screenSize),
            categoryState.when(
            loading: () => _buildLoading(),      
            error: (error, _) => _buildError(error),
            data: (categories) => _buildCategorySelection(screenSize, categories),
            )
          ],
          
          ),
      ),
    );
  }

  // Displays a loading animation while fetching categories
Widget _buildLoading() {
                  final Size screenSize = MediaQuery.of(context).size;
                  return CategorySkeleton(screenSize: screenSize);
                }

  // Displays an error message in case of failure
  Widget _buildError(dynamic error) {
    return Center(
      child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
    );
  }

  // Builds the main category selection UI
  Widget _buildCategorySelection(Size screenSize, List<Map<String, String>> categories) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryRows(screenSize, categories),
          SizedBox(height: screenSize.height * 0.05),
          CategorySelectionButton(
            screenWidth: screenSize.width,
            screenHeight: screenSize.height,
            buttonColor: AppTheme.secondaryColor,
            textColor: AppTheme.textPrimaryColor,
          ),
        ],
      ),
    );
  }

  // Builds the screen title dynamically adjusting text size
  Widget _buildTitle(Size screenSize) {
    return Padding(
      padding: EdgeInsets.only(top: screenSize.height * 0.08),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Elige lo que te ",
              style: TextStyle(
                fontSize: screenSize.width * 0.1,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
                fontFamily: 'Poppins',
              ),
            ),
            TextSpan(
              text: "\ngusta",
              style: TextStyle(
                fontSize: screenSize.width * 0.1,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: 'Poppins',
                height: 0.75,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds category rows dynamically, maintaining the specified structure
  Widget _buildCategoryRows(Size screenSize, List<Map<String, String>> categories) {
    return Column(
      children: [
        // Row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 3, 0),
              child: CircleCategoryWidget(category: categories[10], size: screenSize.width * (102 / 400), fontSize: 16),
            ),
            CircleCategoryWidget(category: categories[12], size: screenSize.width * (135 / 400), fontSize: 16),
          ],
        ),
        // Row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 3, 0),
              child: CircleCategoryWidget(category: categories[11], size: screenSize.width * (85 / 400), fontSize: 12),
            ),
            CircleCategoryWidget(category: categories[0], size: screenSize.width * (104 / 400), fontSize: 12),
            CircleCategoryWidget(category: categories[1], size: screenSize.width * (97 / 400), fontSize: 12),
          ],
        ),
        // Row 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 0, 18),
              child: CircleCategoryWidget(category: categories[13], size: screenSize.width * (67 / 400), fontSize: 9.5),
            ),
            CircleCategoryWidget(category: categories[2], size: screenSize.width * (86 / 400), fontSize: 12),
            CircleCategoryWidget(category: categories[6], size: screenSize.width * (87 / 400), fontSize: 12),
            CircleCategoryWidget(category: categories[4], size: screenSize.width * (63 / 400), fontSize: 12),
          ],
        ),
        // Row 4
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleCategoryWidget(category: categories[8], size: screenSize.width * (112 / 400), fontSize: 16),
            CircleCategoryWidget(category: categories[5], size: screenSize.width * (97 / 400), fontSize: 14),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CircleCategoryWidget(category: categories[9], size: screenSize.width * (82 / 400), fontSize: 10),
            ),
          ],
        ),
        // Row 5
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleCategoryWidget(category: categories[7], size: screenSize.width * (75 / 400), fontSize: 14),
            CircleCategoryWidget(category: categories[3], size: screenSize.width * (91 / 400), fontSize: 14),
          ],
        ),
      ],
    );
  }
}
// Widget for displaying a category item
class CircleCategoryWidget extends ConsumerWidget {
  final Map<String, String> category;
  final double size;
  final double fontSize;

  const CircleCategoryWidget({
    super.key,
    required this.category,
    required this.size,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageCache = ref.watch(imageCacheProvider);
    final Uint8List? cachedImage = imageCache[category["id"]];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4.5),
      child: GestureDetector(
        onTap: () => ref.read(selectedCategoriesProvider.notifier).toggleCategory(category['id']!),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildCategoryImage(cachedImage, category["image"]!),
            _buildOverlay(ref.watch(selectedCategoriesProvider).contains(category["id"])),
            _buildCategoryText(ref.watch(selectedCategoriesProvider).contains(category["id"])),
          ],
        ),
      ),
    );
  }

  // Builds the category image, checking if it's cached
  Widget _buildCategoryImage(Uint8List? cachedImage, String base64String) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: cachedImage != null
              ? MemoryImage(cachedImage)
              : MemoryImage(base64Decode(base64String)),
          fit: BoxFit.cover,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 4))],
      ),
    );
  }

  // Builds the overlay effect when a category is selected
  Widget _buildOverlay(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppTheme.secondaryColor.withOpacity(0.76) : Colors.transparent,
      ),
    );
  }

  // Displays the category text inside the circle
  Widget _buildCategoryText(bool isSelected) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppTheme.secondaryColor.withOpacity(0.56) : Colors.black.withOpacity(0.35),
      ),
      alignment: Alignment.center,
      child: Text(
        category["name"] ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? AppTheme.textPrimaryColor : Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
// Button to confirm category selection and proceed
class CategorySelectionButton extends ConsumerWidget {
  final double screenWidth;
  final double screenHeight;
  final Color buttonColor;
  final Color textColor;

  const CategorySelectionButton({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.buttonColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(selectedCategoriesProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animation when changing state
      child: ElevatedButton(
        onPressed: selectedCategories.isNotEmpty
            ? () {
                context.push('/home');
                print("Categorías seleccionadas: $selectedCategories");
              }
            : null, // Disabled if no categories are selected
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: selectedCategories.isNotEmpty
              ? buttonColor
              : Colors.grey.shade400, // Turns gray when disabled
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
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045,
          ),
        ),
      ),
    );
  }
}