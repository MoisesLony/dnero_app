


import 'package:dnero_app_prueba/presentation/screens/auth/register/complete_info_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/login/login_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/login/otp_screen_login.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/otp_screen_register.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/register_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/categories/categories_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/categories/home_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/prueba.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/prueba2.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/start_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/welcome_screen.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/circular_clipper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {

  static final GoRouter router = GoRouter(

    initialLocation: "/",
    routes: 
    [
      GoRoute(
        path: '/',
        builder: (context, state) =>   StartScreen(),
        ),

        GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child:  LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // from right
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ),

      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child:  RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // from right
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      ),


      GoRoute(
          path: '/otpLogin',
          builder: (context, state) {
            final lastFourDigits  = state.extra as String;
            return OtpScreenLogin(lastFourDigits: lastFourDigits);
          }
        ),
        GoRoute(
          path: '/otpRegister',
          builder: (context, state) {
            final extras = state.extra as Map<String, String>;
            final lastFourDigits  = extras['lastFourDigits']!;
            final phoneNumber = extras['phoneNumber']!;
            return OtpScreenRegister(lastFourDigits: lastFourDigits, phoneNumber: phoneNumber,);
          }
        ),
        GoRoute(
          path: '/complete_info',
          builder:  (context,state){
            final phoneNumber = state.extra as String;
            return CompleteInfoScreen(phoneNumber: phoneNumber);
          }
          ),

          GoRoute(
            path: '/welcome',
            builder: (context, state) => WelcomeScreen(),
            ),

        GoRoute(
            path: '/category',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 600), // ⏳ Duración de la animación
              reverseTransitionDuration: const Duration(milliseconds: 400), // ⏳ Duración al cerrar la pantalla
              child: CategorySelectionScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    double size = Tween<double>(begin: 0.3, end: 1)
                        .chain(CurveTween(curve: Curves.easeInOut))
                        .evaluate(animation);

                    return ClipOval(
                      clipper: CircularClipper(size), // 🔹 Clipper para recortar la animación en forma de círculo
                      child: Transform.scale(
                        scale: size,
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
            ),
          ),

          GoRoute(
            path: '/home',
            builder: (context, state) => HomeScreen(),
            )

    ]
  );
}