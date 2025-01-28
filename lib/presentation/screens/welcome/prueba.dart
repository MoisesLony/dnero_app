import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dnero_app_prueba/presentation/providers/categories_provider.dart';

class TestCategoriesScreen extends ConsumerWidget {
  const TestCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryState = ref.watch(categoriesProvider);
    final String testToken =
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6IjcwODgzMDYyIiwiaWF0IjoxNzM3OTk5MzgzLCJleHAiOjE3MzgwODIxODN9.lHHYCW9ItoX4VogL7yI94xuh9U4p0ofUxilGv1s0R_oJMYObav7C_h_qn8OQwEA7G2TXf3Az866wqDFDiSUnS-iDtrhilutEhw4DwWcCLPWD6W6I4FuNb83ukmNO8MfdTV0trUJqV09uRXs3tyFotR5GOhfyrJ_jPk3XLddIm_5aEOtjBYLCiDbLmchkpmzVAWCd4CGzXBxaWyY1iLBq_1SP3ua2zhIyVTm2R0I-_5HX6GCCtt8WCzcPZVlCSI-9RYUyqcnci1CUVVPUogLq4mu_tG8jDc9CxZytsKwSgXqqVuK44c0XsESzr7eXQKjbzqvj-7n8GOCmmwRybZHW1g";

    // Trigger category fetching
    ref.read(categoriesProvider.notifier).fetchCategories(testToken);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Categories"),
      ),
      body: categoryState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: MemoryImage(
                  base64Decode(category['image'] ?? ''),
                ),
              ),
              title: Text(category['name'] ?? 'Unknown'),
              subtitle: Text('ID: ${category['id']}'),
            );
          },
        ),
      ),
    );
  }
}
