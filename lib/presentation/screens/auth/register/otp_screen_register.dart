import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreenRegister extends ConsumerWidget {
  final String lastFourDigits;
  final String phoneNumber; // Last four digits of the phone number

  const OtpScreenRegister({
    Key? key,
    required this.lastFourDigits,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService _authService = AuthService();
    final TextEditingController _otpController = TextEditingController();
    const String _registredOTP = "0000"; // Registered OTP for validation

    // Function to verify OTP and retrieve token
    void _verifyOtp() async {
      final otp = _otpController.text;

      if (otp != _registredOTP) {
        ShowErrorDialog.show(
            context, "Error", "El OTP ingresado es incorrecto");
        return;
      }
      try {
        final token =
            await _authService.verifyOtp('70883062', otp); // Call API to verify OTP
            ref.read(tokenProvider.notifier).state = token;// Save token using the provider
        context.push('/complete_info', extra: phoneNumber);
        print('Token: $token'); // Print the token for debugging
        // Save the token or proceed to the next step
      } catch (e) {
        print('Error: $e'); // Print error if request fails
      }
    }

    final size = MediaQuery.of(context).size;
    final double scalingFactor = size.height / 812; // Example base height

    const textColor = AppTheme.textPrimaryColor;
    const textColor2 = AppTheme.primaryColor;

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
                "Regístrate",
                style: TextStyle(
                  fontSize: 22 * scalingFactor,
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5 * scalingFactor),
              Text(
                'Escribe el código enviado a',
                style: TextStyle(
                  fontSize: 22 * scalingFactor,
                  color: textColor,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'xxxx-$lastFourDigits', // Getting the last 4 digits
                style: TextStyle(
                    fontSize: 22 * scalingFactor,
                    color: textColor2,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 70 * scalingFactor),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12 * scalingFactor),
                  child: PinCodeTextField(
                    textStyle: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 26 * scalingFactor,
                      fontWeight: FontWeight.bold,
                    ),
                    appContext: context,
                    controller: _otpController, // Controller for OTP input
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    length: 4, // Only 4 digits
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle, // Circular shape
                      fieldHeight: 70 * scalingFactor, // Circle height
                      fieldWidth: 70 * scalingFactor, // Circle width
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
                      _otpController.text = v;
                      _verifyOtp();
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
