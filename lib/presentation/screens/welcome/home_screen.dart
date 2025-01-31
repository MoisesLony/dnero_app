import 'dart:typed_data';
import 'package:dnero_app_prueba/presentation/widgets/image/image_widget.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../../providers/provider_barril.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

void _logoutAndRestart() {
  // ✅ Show logout animation before navigating
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 1500),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 1.0, // Start at normal size
          end: 0.0, // Shrinks to zero
        ).animate(animation),
        child: const Center(
          child: CircularProgressIndicator(), 
        ),
      );
    },
  );

  // ✅ Reset authentication and user session
  ref.read(tokenProvider.notifier).state = null;
  ref.invalidate(userInfoProvider);
  ref.invalidate(recommendationsProvider);
  ref.invalidate(categoriesProvider);
  ref.invalidate(selectedCategoriesProvider);
  ref.invalidate(profileImageProvider);
  ref.invalidate(formFieldsProvider);
  ref.invalidate(isLoadingProvider);
  ref.read(imageCacheProvider.notifier).clearImage("user_profile");

  // ✅ Redirect after animation
  Future.delayed(const Duration(milliseconds: 500), () {
    Navigator.of(context).pop(); // Close the animation
    context.go('/'); // Go to the initial route
  });
}
  
  
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);
    final size = MediaQuery.of(context).size;
    final double scalingFactor = ((size.width / 375) + (size.height / 812)) / 2;

    return Scaffold(
      // ✅ Drawer with logout option
      drawer: DrawerWidget(onLogout: _logoutAndRestart),

      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ Main content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(userInfo,context),
                _buildUserInfo(userInfo,context),
                _buildStats(context),
                Transform.translate(
                  offset: const Offset(0, 22),
                  child:  Padding(  
                    padding: EdgeInsets.fromLTRB(0, 0, 125, 0),
                    child: Text(
                      "Recomendaciones",
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontFamily: 'Poppins',
                        fontSize: 18 * scalingFactor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0 * scalingFactor),
                const RecommendationsSection(),
                SizedBox(height: 50 * scalingFactor),
              ],
            ),
          ),

          // ✅ Floating button to open the Drawer
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                    padding:  EdgeInsets.only(top:40 * scalingFactor, left: 15 * scalingFactor),
                    child: Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10) * scalingFactor,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1), 
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
              ],
            ),
      // ✅ BottomNavigationBar (inactive)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 2 * scalingFactor,
          currentIndex: _selectedIndex,
          onTap: (index) {}, // No functionality
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: "Friends",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_outlined),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: "Bookmarks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: "Notifications",
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _buildHeader(Map<String, dynamic> userInfo, BuildContext context) {
  const backgroundColor = AppTheme.primaryColor;
  final double screenHeight = MediaQuery.of(context).size.height; // Get screen height

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: double.infinity,
        height: screenHeight * 0.27, // 27% of screen height
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(screenHeight * 0.06),
            bottomRight: Radius.circular(screenHeight * 0.06),
          ),
        ),
      ),
      Positioned(
        bottom: screenHeight * 0.02, // Adjust position based on screen height
        child: ProfileImageWidget(imageData: userInfo['decodedImage']),
      ),
    ],
  );
}

Widget _buildUserInfo(Map<String, dynamic> userInfo, BuildContext context) {
  final textcolor = AppTheme.primaryColor;
  final double screenWidth = MediaQuery.of(context).size.width; // Get screen width

  return Padding(
    padding: EdgeInsets.only(top: screenWidth * 0.08, bottom: screenWidth * 0.05),
    child: Column(
      children: [
        Text(
          "${userInfo['firstName']} ${userInfo['lastName']}",
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.w600,
            color: textcolor,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: textcolor, size: screenWidth * 0.06),
            Text(
              "Santa Ana, SV",
              style: TextStyle(
                fontSize: screenWidth * 0.05, // Responsive font size
                color: textcolor,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStats(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  const textColor = AppTheme.textPrimaryColor;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenWidth * 0.05),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("900",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
            Text("Followers",
                style: TextStyle(fontSize: screenWidth * 0.045, color: textColor, fontFamily: 'Poppins')),
          ],
        ),
        Column(
          children: [
            Text("200",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
            Text("Following",
                style: TextStyle(fontSize: screenWidth * 0.045, color: textColor, fontFamily: 'Poppins')),
          ],
        ),
      ],
    ),
  );
}

class RecommendationsSection extends ConsumerWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final double screenHeight = MediaQuery.of(context).size.height; // Get screen height
    final double widthFactor = 149 / screenWidth;
    final double heightFactor = 177 / screenHeight;
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Dynamic padding
      child: recommendationsAsync.when(
        data: (recommendations) {
          if (recommendations.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.06), // Dynamic vertical spacing
                child: Text(
                  "No hay recomendaciones disponibles",
                  style: TextStyle(fontSize: screenWidth * 0.045), // Responsive text size
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Dynamic horizontal padding
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.03, // Dynamic spacing
                mainAxisSpacing: screenWidth * 0.03,
                childAspectRatio: (screenWidth * widthFactor) / (screenHeight * heightFactor),// Adaptive ratio
              ),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
                return RecommendationCard(recommendation: recommendation);
              },
            ),
          );
        },
        loading: () => const SkeletonGridLoader(),
        error: (error, stackTrace) {
          print("❌ Error loading recommendations: $error");
          return Center(
            child: Text(
              "Failed to load recommendations",
              style: TextStyle(fontSize: screenWidth * 0.045), // Responsive error text
            ),
          );
        },
      ),
    );
  }
}


// Skeleton Screen loading recomendation
class SkeletonGridLoader extends StatelessWidget {
  const SkeletonGridLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widthFactor = 149 / screenWidth;
    final double heightFactor = 177 / screenHeight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Dynamic padding
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: screenWidth * 0.03, // Dynamic spacing
          mainAxisSpacing: screenWidth * 0.03,
          childAspectRatio: (screenWidth * widthFactor) / (screenHeight * heightFactor), // Adaptive ratio
        ),
        itemCount: 6, // Default placeholders
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(screenWidth * 0.05), // Dynamic border radius
            ),
          );
        },
      ),
    );
  }
}


class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final Uint8List? imageBytes = recommendation['decodedImage'] as Uint8List?;
    final double rating = (recommendation['calification'] as num?)?.toDouble() ?? 5.0;
    final int roundedRating = rating.floor();

    return GestureDetector(
      onTap: () {
        context.push('/recommendationDetails', extra: recommendation);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Dynamic border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: screenWidth * 0.015, // Dynamic blur radius
              spreadRadius: screenWidth * 0.002, // Dynamic spread radius
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.05), // Dynamic border radius
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: imageBytes != null
                      ? DecorationImage(image: MemoryImage(imageBytes), fit: BoxFit.cover)
                      : const DecorationImage(image: AssetImage("assets/images/default.jpg"), fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenWidth * 0.04), // Dynamic padding
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ...List.generate(
                          roundedRating,
                          (_) => Image.asset(
                            'assets/background/icono.png',
                            width: screenWidth * 0.04, // Dynamic icon size
                            height: screenWidth * 0.035, // Dynamic icon size
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.01), // Dynamic spacing
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.03, // Dynamic font size
                          ),
                        ),
                      ],
                    ),
                    Text(
                      recommendation['title'] ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.028, // Dynamic font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

