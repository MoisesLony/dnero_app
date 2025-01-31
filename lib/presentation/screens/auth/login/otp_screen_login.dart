import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/error_dialog.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/otp_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreenLogin extends ConsumerWidget {
  final String lastFourDigits; // Last four digits of the phone number

  const OtpScreenLogin({Key? key, required this.lastFourDigits}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final otpController = TextEditingController();
    final double scalingFactor = MediaQuery.of(context).size.height / 812;
    const String registeredOtp = '0000'; // Registered OTP for validation

    const textColor = AppTheme.textPrimaryColor;
    const textColor2 = AppTheme.primaryColor;

    Future<void> verifyOtp() async {
      final otp = otpController.text;

      if (otp != registeredOtp) {
        ShowErrorDialog.show(context, "Error", "El OTP ingresado es incorrecto");
        return;
      }
      if (!context.mounted) return;

      try {
        final token = await authService.verifyOtp('70883062', otp); // API call to verify OTP
        ref.read(tokenProvider.notifier).state = token; // Save token using provider
        context.go('/welcome');
      } catch (e) {
        print('Error: $e'); // Log error if API request fails
      }
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0 * scalingFactor),
          child: Column(
            children: [
              OtpWidget(
                scalingFactor: scalingFactor,
                lastFourDigits: lastFourDigits,
                textColor: textColor,
                textColor2: textColor2,
                text: 'Iniciar Sesión',
              ),
              SizedBox(height: 40 * scalingFactor),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10 * scalingFactor),
                  child: PinCodeTextField(
                    textStyle: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 26 * scalingFactor,
                      fontWeight: FontWeight.bold,
                    ),
                    appContext: context,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    length: 4, // OTP is 4 digits long
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      fieldHeight: 70 * scalingFactor,
                      fieldWidth: 70 * scalingFactor,
                      activeFillColor: const Color.fromARGB(255, 247, 247, 247),
                      inactiveFillColor: const Color.fromARGB(255, 247, 247, 247),
                      selectedFillColor: const Color.fromARGB(255, 247, 247, 247),
                      activeColor: Colors.transparent,
                      inactiveColor: Colors.transparent,
                      selectedColor: Colors.transparent,
                      activeBoxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                      inActiveBoxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    enableActiveFill: true,
                    cursorColor: textColor,
                    onCompleted: (v) {
                      otpController.text = v;
                      verifyOtp();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
