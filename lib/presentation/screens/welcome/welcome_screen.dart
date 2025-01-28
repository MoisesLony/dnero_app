import 'package:animate_do/animate_do.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:dnero_app_prueba/presentation/providers/user_info.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/background_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final heightFactor = size.height / 812; // Normalize height
    final widthFactor = size.width / 375; // Normalize width
    final Color secondaryTextColor = AppTheme.primaryColor;
    final String token2 = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjcwODgzMDYyIiwiaWF0IjoxNzM3OTk5MzgzLCJleHAiOjE3MzgwODIxODN9.lHHYCW9ItoX4VogL7yI94xuh9U4p0ofUxilGv1s0R_oJMYObav7C_h_qn8OQwEA7G2TXf3Az866wqDFDiSUnS-iDtrhilutEhw4DwWcCLPWD6W6I4FuNb83ukmNO8MfdTV0trUJqV09uRXs3tyFotR5GOhfyrJ_jPk3XLddIm_5aEOtjBYLCiDbLmchkpmzVAWCd4CGzXBxaWyY1iLBq_1SP3ua2zhIyVTm2R0I-_5HX6GCCtt8WCzcPZVlCSI-9RYUyqcnci1CUVVPUogLq4mu_tG8jDc9CxZytsKwSgXqqVuK44c0XsESzr7eXQKjbzqvj-7n8GOCmmwRybZHW1g";

    // Fetch token
    final token = ref.watch(tokenProvider);

    // Fetch user info when the widget builds
    if (token2 != null && ref.read(userInfoProvider).isEmpty) {
      ref.read(userInfoProvider.notifier).fetchUserInfo(token2);
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
                    if (token2 == null) {
                      return const Center(
                        child: CircularProgressIndicator(), // Show loading when token is null
                      );
                    }

                    if (userInfo.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(), // Show loading when userInfo is empty
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
                        BounceInDown(
                          from: 100,
                          duration: const Duration(seconds: 2),
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
                        ),
                        
                        SizedBox(height: 5 * heightFactor),
                        FadeInRightBig(
                          duration: const Duration(seconds: 2),
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
                        BounceInUp(
                          duration: const Duration(seconds: 2),
                          from: 250,
                          child: SizedBox(
                            width: 275 * heightFactor,
                            height: 50 * heightFactor,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/category');
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
