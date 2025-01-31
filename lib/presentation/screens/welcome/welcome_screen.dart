import 'package:animate_do/animate_do.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/background_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final heightFactor = size.height / 812; // Normalize height
    final widthFactor = size.width / 375; // Normalize width
    final Color secondaryTextColor = AppTheme.primaryColor;
    
    // Fetch token
    final token = ref.watch(tokenProvider);

    // Fetch user info when the widget builds
    if (token != null && ref.read(userInfoProvider).isEmpty) {
      ref.read(userInfoProvider.notifier).fetchUserInfo(token);
    }

    

    // Observe user info state
    final userInfo = ref.watch(userInfoProvider);

    
    return Scaffold(
      
      body: Stack(
        children: [
          // Background video
          const SizedBox.expand(
            child: BackgroundVideo(),
          ),
          // Content overlay
          Padding(
            padding: EdgeInsets.only(bottom: 320 * heightFactor), // Adjusted top padding
            child: SafeArea(
              child: Center(
                child: Builder(
                  builder: (_) {
                    if (token == null) {
                      return  Center(child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.transparent,
                          size: 150,
                          )
                        );
                    }
                    

                    if (userInfo.isEmpty) {
                      return Center(child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.transparent,
                          size: 150,
                          )
                        );
                    }
                    

                    if (userInfo.containsKey('error')) {
                      return Center(
                        child: Text(
                          'Error: ${userInfo['error']}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                  // Render user information when available
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.5, end: 1.0), // Starts smaller and grows to normal size
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOut, // Makes the animation smoother
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value, // 🔥 Applies gradual scaling effect
                            child: Text(
                                    "¡Hola, ${userInfo['firstName']}!",
                                    style: TextStyle(
                                      fontSize: 40 * heightFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      height: 1.3,
                                    ),
                                  ),
                                );
                              },
                            ),

                        
                        SizedBox(height: 5 * heightFactor),
                        FadeIn(
                          duration: const Duration(milliseconds: 1500 ),
                          delay: const Duration(milliseconds: 1500 ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Bienvenido/a\na un mundo\nlleno\nde ",
                                  style: TextStyle(
                                    fontSize: 40 * heightFactor,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: "aventuras",
                                  style: TextStyle(
                                    fontSize: 40 * heightFactor,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryTextColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * heightFactor),
                        FadeInUp(
                          delay: const Duration(milliseconds: 3000),
                          duration: const Duration(milliseconds : 1500),
                          from: 250,
                          child: SizedBox(
                            width: 275 * heightFactor,
                            height: 50 * heightFactor,
                            child: ElevatedButton(
                              onPressed: () {
                                context.go('/category');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30 * widthFactor),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Comenzar Aventura",
                                style: TextStyle(
                                  fontSize: 18 * heightFactor,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1C2F56),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 40 * heightFactor), // Bottom spacing
        ],
      ),
    );
  }
}