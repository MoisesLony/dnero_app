import 'dart:typed_data';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:dnero_app_prueba/presentation/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/presentation/providers/user_info.dart';
import 'package:dnero_app_prueba/presentation/providers/categories/recommendations_categories_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  int _selectedIndex = 0; // Guarda el índice de la pestaña seleccionada


  final List<String> _routes = [
    '/home', // Ruta para Home
    '/friends', // Ruta para Amigos
    '/add', // Ruta para Agregar
    '/bookmarks', // Ruta para Guardados
    '/notifications', // Ruta para Notificaciones
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navega a la ruta correspondiente
    context.push(_routes[index]);
  }

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  
    
    Future.microtask(() {
      final token = ref.watch(tokenProvider);
      ref.read(userInfoProvider.notifier).fetchUserInfoWithImages(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: userInfo.isEmpty
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(userInfo),
                  _buildUserInfo(userInfo),
                  _buildStats(),
                  Transform.translate(
                    offset: const Offset(0, 22),
                    child: const Padding(
                      padding:  EdgeInsets.fromLTRB(0, 0,  125, 0),
                          child: Text("Recomendaciones",style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),),
                      ),
                  ),
                  const SizedBox(height: 0), 
                  const RecommendationsSection(),
                  const SizedBox(height: 50,)
                ],
              ),
            ),

            // 🚀 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Color del icono seleccionado
        unselectedItemColor: Colors.grey, // Color del icono no seleccionado
        showSelectedLabels: false, // Oculta etiquetas seleccionadas
        showUnselectedLabels: false, // Oculta etiquetas no seleccionadas
        type: BottomNavigationBarType.fixed, // Mantiene tamaño estable

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: "Amigos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            label: "Agregar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: "Guardados",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Notificaciones",
          ),
        ],
      ),
    );
  }
  Widget _buildHeader(Map<String, dynamic> userInfo) {
    final backgroundColor = AppTheme.primaryColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 220, 
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Positioned(
          bottom: 18,
          child: ProfileImageWidget(imageData: userInfo['decodedImage']),
        ),
      ],
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> userInfo) {
    final textcolor = AppTheme.primaryColor;
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        children: [
          Text(
            "${userInfo['firstName']} ${userInfo['lastName']}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textcolor,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: textcolor),
              Text(
                "Santa Ana, SV",
                style: TextStyle(fontSize: 20, color: textcolor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    const textColor = AppTheme.textPrimaryColor;
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("900", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
              Text("Seguidores", style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'Poppins')),
            ],
          ),
          Column(
            children: [
              Text("200", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
              Text("Siguiendo", style: TextStyle(fontSize: 16, color: textColor, fontFamily: 'Poppins')),
            ],
          ),
        ],
      ),
    );
  }
}

class RecommendationsSection extends ConsumerWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: recommendationsAsync.when(
        data: (recommendations) {
          if (recommendations.isEmpty) {
            return const Center(child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text("No hay recomendaciones"),
            ));
          }
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true, 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82, 
              ),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
                return RecommendationCard(recommendation: recommendation);
              },
            ),
          );
        },
        loading: () => Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: AppTheme.primaryColor,
                          size: 150,
                        ),
                      ),
        error: (error, stackTrace) {
          print("❌ Error loading recommendations: $error");
          return const Center(child: Text("Failed to load recommendations"));
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
    final Uint8List? imageBytes = recommendation['decodedImage'] as Uint8List?;
    final double rating = (recommendation['calification'] as num?)?.toDouble() ?? 5.0;
    final int roundedRating = rating.floor();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [...List.generate(roundedRating, (_) => Image.asset('assets/background/icono.png', width: 14, height: 12)), const SizedBox(width: 5), Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 8))]),
                  Text(recommendation['title'] ?? 'No Title', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
