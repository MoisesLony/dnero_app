import 'dart:io';
import 'package:dnero_app_prueba/config/helper/resize_image.dart';
import 'package:dnero_app_prueba/config/theme/app_theme.dart';
import 'package:dnero_app_prueba/infrastructure/datasources/remote/aut_service.dart';
import 'package:dnero_app_prueba/presentation/providers/form_fields.dart';
import 'package:dnero_app_prueba/presentation/providers/profile_image_provider.dart';
import 'package:dnero_app_prueba/presentation/providers/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
      if (formFields.name.isEmpty || formFields.lastName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nombre y Apellido son obligatorios"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: Token no encontrado"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

// Resize the selected profile image to optimize its size and quality before sending it to the server. 
// If no image is selected or there is an error during resizing, show an error message and stop the submission process.
      File? resizedFile;
        if (profileImage != null) {
          final file = File(profileImage.path);
          resizedFile = await ImageUtils.resizeImage(file, width: 800, quality: 80);
        if (resizedFile == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error al procesar la imagen"),
                backgroundColor: Colors.red,
              ),
            );
          return;
        }
      }

      try {
        // Update the user information through the repository
        await AuthRepositoryImpl(AuthService()).updateUser(
          firstName: formFields.name,
          lastName: formFields.lastName,
          email: formFields.email,
          image: resizedFile, // Send the resized file
          token: token,
        );
        context.go('/welcome');
  
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al actualizar la información: $e"),
            backgroundColor: Colors.red,
          ),
        );
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
                    SizedBox(height: 30 * heightFactor),
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
                 width:  90 * heightFactor,
                  height: 40 * heightFactor,
                  child: ElevatedButton(
                    onPressed: submitInfo,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25 * widthFactor),
                      ),
                    ),
                    child: Text(
                      "Comenzar",
                      style: TextStyle(
                        fontSize: 13.5 * heightFactor,
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
    final Color textColor = AppTheme.textPrimaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the text field
        
        // Text field for user input
        TextField(
          onChanged: onChanged,

          style: TextStyle(
            fontSize: 16,
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
            contentPadding: const EdgeInsets.only(bottom: -8),
          ),
        ),
        SizedBox(height: 33),
      ],
    );
  }
}
