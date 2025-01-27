import 'package:animate_do/animate_do.dart';
import 'package:dnero_app_prueba/config/helper/format_phone_number.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/domain/usecases/verify_phone_usecase.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/infrastructure/repositories/auth_repository_impl.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Create a focus node
  late final VerifyPhoneUsecase _verifyPhoneUseCase;
  bool _isLoading = false;

  final List<String> _validMockPhones = [
    "7088-3062", // Preexisting number
    "1234-5678", // Mock number 1
    "8765-4321", // Mock number 2
    "1122-3344", // Mock number 3
  ];

  @override
  void initState() {
    super.initState();
    // Initialize VerifyPhoneUseCase with the repository implementation
    _verifyPhoneUseCase = VerifyPhoneUsecase(
      AuthRepositoryImpl(_authService),
    );
  }

  @override
  void dispose() {
    // Dispose the controller and focus node
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phone = _phoneController.text;

    if (phone.isEmpty){
      ShowErrorDialog.show(context, "Error", "Debes de introducir un número");
      return;
    }

    if (phone.length !=9){
      ShowErrorDialog.show(context,"Error", "El número debe contener exactamente 8 dígitos");
      return;
    }

    if (!_validMockPhones.contains(phone)) {
      ShowErrorDialog.show(
          context, "Error", "El número introducido no esta registrado");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String lastFourDigits = phone.length >= 4 ? phone.substring(phone.length - 4) : phone;
    try {
      await _verifyPhoneUseCase.execute(phone);
      context.push("/otpLogin", extra: lastFourDigits);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Failed to send OTP"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Phone Number format
  

  @override
  Widget build(BuildContext context) {
    const Color textColorBlue = AppTheme.textPrimaryColor;
    const Color buttonColor = AppTheme.secondaryColor;
    
    final size = MediaQuery.of(context).size;
    const double baseHeight = 812; // Example: base height used for scaling
    final double scalingFactor = size.height / baseHeight;
    

  
    return GestureDetector(
      // Detect taps outside the TextField
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
    
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              expandedHeight: 0,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
              background: Container(color: Colors.white),
              
                ),
              ),
          SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0 * scalingFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15 * scalingFactor),
                  child: FadeInRight(
                    child: Text(
                      "Inicia Sesión",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24 * scalingFactor,
                        color: textColorBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 160 * scalingFactor),
                // Phone number input field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15 * scalingFactor),
                  child: Text(
                    'Ingresa tu número\ntelefónico:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 27 * scalingFactor,
                      color: textColorBlue,
                      height: 1.2,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
                SizedBox(height: 30 * scalingFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15 * scalingFactor),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FormatPhoneNumber(),//formart number 0000-0000
                      
                    ],
                    
                    textAlign: TextAlign.start,
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus(); // Dismiss the keyboard
                    },
                    decoration: InputDecoration(
                      hintText: '0000-0000',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColorBlue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromRGBO(28, 47, 86, 1),
                          width: 2 * scalingFactor,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18 * scalingFactor,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 155 * scalingFactor),
                Center(
                  child: Text(
                    "Te enviaremos un código de uso único a tu dispositivo.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      fontSize: 16 * scalingFactor,
                      color: textColorBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20 * scalingFactor),
                Center(
                  child: SizedBox(
                    width: 340 * scalingFactor,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? Colors.grey : buttonColor,
                        foregroundColor: textColorBlue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40 * scalingFactor,
                          vertical: 12 * scalingFactor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20 * scalingFactor),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Siguiente',
                              style: TextStyle(
                                fontSize: 16 * scalingFactor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
          ]
      ),
      )
    );
  }
}
