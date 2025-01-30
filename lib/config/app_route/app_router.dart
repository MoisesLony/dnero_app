import 'package:dnero_app_prueba/presentation/screens/categories/recommendations_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dnero_app_prueba/presentation/screens/auth/login/login_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/login/otp_screen_login.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/register_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/otp_screen_register.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/complete_info_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/categories/categories_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/categories/home_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/start_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/welcome_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => StartScreen(),
      ),

      // Login screen with slide transition
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // Starts from the right
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      // Register screen with slide transition
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // Starts from the right
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      // OTP Login screen with slide transition
      GoRoute(
        path: '/otpLogin',
        pageBuilder: (context, state) {
          final lastFourDigits = state.extra as String;
          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpScreenLogin(lastFourDigits: lastFourDigits),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Starts from the right
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      // OTP Register screen with slide transition
      GoRoute(
        path: '/otpRegister',
        pageBuilder: (context, state) {
          final extras = state.extra as Map<String, String>;
          final lastFourDigits = extras['lastFourDigits']!;
          final phoneNumber = extras['phoneNumber']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpScreenRegister(
              lastFourDigits: lastFourDigits,
              phoneNumber: phoneNumber,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0), // Starts from the right
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      // Complete Info screen
      GoRoute(
        path: '/complete_info',
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return CompleteInfoScreen(phoneNumber: phoneNumber);
        },
      ),

      // Welcome screen
      GoRoute(
        path: '/welcome',
        builder: (context, state) => WelcomeScreen(),
      ),

      // Category selection screen with slide transition from bottom
      GoRoute(
        path: '/category',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          child: const CategorySelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1), // Starts from the bottom
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      // Home screen with fade transition
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500), // Fade duration
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
          },
        ),
      ),


      GoRoute(
          path: '/recommendationDetails',
          builder: (context, state) {
            final recommendation = state.extra as Map<String, dynamic>;
            return RecommendationDetailsScreen(recommendation: recommendation);
          },
),
    ],
  );
}
