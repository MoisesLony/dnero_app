  import 'dart:io';
  import 'package:dnero_app_prueba/config/helper/resize_image.dart';
  import 'package:dnero_app_prueba/config/theme/app_theme.dart';
  import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
  import 'package:dnero_app_prueba/presentation/providers/form_fields.dart';
  import 'package:dnero_app_prueba/presentation/providers/profile_image_provider.dart';
  import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
  import 'package:dnero_app_prueba/presentation/providers/utils/is_loading_provider.dart';
import 'package:dnero_app_prueba/presentation/widgets/shared/error_dialog.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:go_router/go_router.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:loading_animation_widget/loading_animation_widget.dart';
  import '../../../../infrastructure/repositories/auth_repository_impl.dart';

  class CompleteInfoScreen extends ConsumerWidget {
    final String phoneNumber;


    const CompleteInfoScreen({
      Key? key,
      required this.phoneNumber,
    }) : super(key: key);

    // Method to format the phone number
    String _formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.length == 8) {
        return '${phoneNumber.substring(0, 4)}-${phoneNumber.substring(4, 8)}';
      }
      return phoneNumber;
    }

    @override
    Widget build(BuildContext context, WidgetRef ref) {

      final _isLoading = ref.watch(isLoadingProvider);

      // Watch the current state of the form fields
      final formFields = ref.watch(formFieldsProvider);
      // Watch the current state of the profile image
      final profileImage = ref.watch(profileImageProvider);
      // Watch the current token value
      final token = ref.watch(tokenProvider);

      const textColor = Color(0xFF1C2F56);
      const buttonColor = Color(0xFF7DFC92);

      final size = MediaQuery.of(context).size;
      final widthFactor = size.width / 375;
      final heightFactor = size.height / 812;

      final formattedNumber = _formatPhoneNumber(phoneNumber);

      // Function to select an image from the gallery
      Future<void> pickImage() async {
        final imagePicker = ImagePicker();

        try {
          final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            print('Selected image path: ${pickedImage.path}'); // Verify the image path
            ref.read(profileImageProvider.notifier).state = pickedImage;
          }
        } catch (e) {
          print('Error picking image: $e');
        }
      }
      
    
// Function to submit the form data
Future<void> submitInfo() async {
  ref.read(isLoadingProvider.notifier).state = true;

  // 🔴 1. Validate that fields are not empty
  if (formFields.name.isEmpty || formFields.lastName.isEmpty) {
    await showDialog(
      context: context,
      builder: (context) => const ShowErrorDialog(
        message: 'Nombre y apellido son requeridos',
        title: 'Error',
      ),
    );
    ref.read(isLoadingProvider.notifier).state = false; // ✅ Unlock button
    return;
  }

  // 🔴 2. Validate that the token is not null
  if (token == null) {
    await showDialog(
      context: context,
      builder: (context) => const ShowErrorDialog(
        message: 'Error: Token no encontrado',
        title: 'Error',
      ),
    );
    ref.read(isLoadingProvider.notifier).state = false; // ✅ Unlock button
    return;
  }

  // 🔴 3. Resize the image before uploading
  File? resizedFile;
  if (profileImage != null) {
    final file = File(profileImage.path);
    resizedFile = await ImageUtils.resizeImage(file, width: 800, quality: 80);

    if (resizedFile == null) {
      await showDialog(
        context: context,
        builder: (context) => const ShowErrorDialog(
          message: 'No se pudo procesar la imagen',
          title: 'Error',
        ),
      );
      ref.read(isLoadingProvider.notifier).state = false; // ✅ Unlock button
      return;
    }
  }

  try {
    // 🔵 4. Send data to the server
    await AuthRepositoryImpl(AuthService()).updateUser(
      firstName: formFields.name,
      lastName: formFields.lastName,
      email: formFields.email,
      image: resizedFile,
      token: token,
    );

    // 🔵 5. Redirect the user
    context.go('/welcome');
  } catch (e) {
    await showDialog(
      context: context,
      builder: (context) => ShowErrorDialog(
        message: "Error updating information: $e",
        title: "Error",
      ),
    );
  } finally {
    ref.read(isLoadingProvider.notifier).state = false; // ✅ Ensure button is enabled at the end
  }
}

      return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: Colors.white,),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.0 * widthFactor),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Text(
                    "Completa tu información",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24 * heightFactor,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(height: 30 * heightFactor),
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60 * heightFactor ,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profileImage != null
                              ? FileImage(File(profileImage.path))
                              : null,
                          child: profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        CircleAvatar(
                          radius: 16 * widthFactor,
                          backgroundColor: textColor,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 22 * widthFactor,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20 * heightFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25 * widthFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Build the name input field
                      _buildTextField(
                        label: "Nombre",
                        value: formFields.name,
                        onChanged: (value) =>
                            ref.read(formFieldsProvider.notifier).updateName(value),
                      ),
                      // Build the last name input field
                      _buildTextField(
                        label: "Apellido",
                        value: formFields.lastName,
                        onChanged: (value) =>
                            ref.read(formFieldsProvider.notifier).updateLastName(value),
                      ),
                      // Build the email input field
                      _buildTextField(
                        label: "Tu Correo",
                        value: formFields.email,
                        onChanged: (value) =>
                            ref.read(formFieldsProvider.notifier).updateEmail(value),
                      ),
                      SizedBox(height: 5 * heightFactor),
                      Text(
                        "Tu Número de teléfono",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14 * heightFactor,
                        ),
                      ),
                      SizedBox(height: 10 * heightFactor),
                      Text(
                        formattedNumber,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16 * heightFactor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80 * heightFactor),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * (303 / 375),
                     height: MediaQuery.of(context).size.height * (42 / 812),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : submitInfo,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25 * widthFactor),
                        ),
                        
                      ),
                      
                      child: _isLoading
                    ? Center( 
                        child: LoadingAnimationWidget.waveDots(
                          color: AppTheme.textPrimaryColor,
                          size: 25,
                        ),
                      )
                    : Text(
                        "Comenzar",
                        style: TextStyle(
                          fontSize: 14 * heightFactor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: textColor,
                        ),
                      ),
                    ),
                    
                  ),
                ),
                
              ],
              
            ),
            
          ),
          
        ),
    
      ],
    ),
  );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final Color textColor = AppTheme.textPrimaryColor;
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text field for user input
            TextField(
              onChanged: onChanged,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Dynamic font size based on screen width
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: textColor,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: value,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.3), width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor, width: 2),
                ),
                contentPadding: EdgeInsets.only(bottom: screenHeight * -0.01), // Dynamic padding
              ),
            ),
            SizedBox(height: screenHeight * 0.04), // Dynamic spacing
          ],
        );
      },
    );
  }
}