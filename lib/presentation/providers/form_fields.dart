import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model for the form fields
class FormFields {
  final String name;
  final String lastName;
  final String email;

  FormFields({
    this.name = '',
    this.lastName = '',
    this.email = '',
  });

  // Method to create a new instance with updated values
  FormFields copyWith({
    String? name,
    String? lastName,
    String? email,
  }) {
    return FormFields(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }
}

// Notifier to manage the fields' state
class FormFieldsNotifier extends StateNotifier<FormFields> {
  FormFieldsNotifier() : super(FormFields());

  // Method to update the name field
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  // Method to update the last name field
  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  // Method to update the email field
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
}

// Provider to expose the state of the fields
final formFieldsProvider = StateNotifierProvider<FormFieldsNotifier, FormFields>(
  (ref) => FormFieldsNotifier(),
);
