


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
import 'package:dnero_app_prueba/presentation/widgets/custom_page_route.dart';
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
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      child: const CategorySelectionScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // Comienza desde abajo
            end: Offset.zero,          // Llega a su posición normal
          ).animate(animation),
          child: child,
        );
      },
    );
  },
),





          GoRoute(
  path: '/home',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 500), // Duration of fade in

    
    child: const HomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: child,
      );
    },
  ),
),


    ]
  );
}