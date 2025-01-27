import 'package:dnero_app_prueba/config/app_route/app_router.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreenLogin extends ConsumerWidget {
  final String lastFourDigits; // Last four digits of the phone number

  const OtpScreenLogin({
    Key? key,
    required this.lastFourDigits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = AuthService();
    final otpController = TextEditingController();
    final double scalingFactor = MediaQuery.of(context).size.height / 812;
    final String _registredOTP= '0000';

    const textColor = AppTheme.textPrimaryColor;
    const textColor2 = AppTheme.primaryColor;

    Future<void> verifyOtp() async {
      final otp = otpController.text;

      if (otp != _registredOTP) {
        ShowErrorDialog.show(context, "Error", "The entered OTP is incorrect");
        return;
      }
      if (!context.mounted) return;

      try {
        final token = await authService.verifyOtp('70883062', otp); // Call API to verify OTP
        ref.read(tokenProvider.notifier).state = token; // Save token using the provider

        ShowErrorDialog.show(context, "Error", "si ${token}");
        print('Token: $token'); // Print the token for debugging
      } catch (e) {
        ShowErrorDialog.show(context, "Error", "Failed to verify the OTP");
        print('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0 * scalingFactor),
          child: Column(
            children: [
              Text(
                "Iniciar sesión",
                style: TextStyle(
                  fontSize: 22 * scalingFactor,
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5 * scalingFactor),
              Text(
                'Enter the code sent to',
                style: TextStyle(
                  fontSize: 22 * scalingFactor,
                  color: textColor,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'xxxx-$lastFourDigits',
                style: TextStyle(
                  fontSize: 22 * scalingFactor,
                  color: textColor2,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 70 * scalingFactor),
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
                    length: 4, // Only 4 digits
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle, // Circular shape
                      fieldHeight: 70 * scalingFactor, // Field height
                      fieldWidth: 70 * scalingFactor, // Field width
                      activeFillColor: const Color.fromARGB(255, 247, 247, 247), // Active background color
                      inactiveFillColor: const Color.fromARGB(255, 247, 247, 247), // Inactive background color
                      selectedFillColor: const Color.fromARGB(255, 247, 247, 247), // Selected background color
                      activeColor: Colors.transparent, // No border for active
                      inactiveColor: Colors.transparent, // No border for inactive
                      selectedColor: Colors.transparent, // No border for selected
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
