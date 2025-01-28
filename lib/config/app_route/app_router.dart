


import 'package:dnero_app_prueba/presentation/screens/auth/register/complete_info_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/login/login_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/login/otp_screen_login.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/otp_screen_register.dart';
import 'package:dnero_app_prueba/presentation/screens/auth/register/register_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/categories/categories_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/home_screen.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/prueba.dart';
import 'package:dnero_app_prueba/presentation/screens/welcome/welcome_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: 
    [
      GoRoute(
        path: '/',
        builder: (context, state) =>  const HomeScreen(),
        ),

      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),

      GoRoute
      (path: "/register",
      builder: (context,state) => const RegisterScreen(),
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
            builder: (context, state) =>  WelcomeScreen(),
            ),

            GoRoute(path: '/category',
            builder: (context, state) => CategorySelectionScreen(),
            )
    ]
  );
}