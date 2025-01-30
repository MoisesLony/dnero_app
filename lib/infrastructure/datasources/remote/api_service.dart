import 'dart:convert';
import 'dart:io';
import 'package:dnero_app_prueba/config/constants/enviroment.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = Enviroment.baseUrl;

  /* =======================================================
    General method for POST requests (JSON data)
     ======================================================= */
  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Include token if available
    };

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body); // Decode JSON response if successful
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}'); // Throw error for other status codes
    }
  }

  /* =======================================================
    Method for POST requests with multipart/form-data
     ======================================================= */
  Future<dynamic> postMultipart(
    String endpoint,
    Map<String, String> fields, {
    required String fileFieldName,
    required File file,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    // Add token to headers if available
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add form fields
    request.fields.addAll(fields);

    // Attach the file
    request.files.add(await http.MultipartFile.fromPath(fileFieldName, file.path));

    // Send the request
    final response = await request.send();

    // Parse the response
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(responseBody); // Decode JSON response if successful
    } else {
      throw Exception('Error ${response.statusCode}: $responseBody'); // Throw error for other status codes
    }
  }

  /* =======================================================
    Method for GET requests
     ======================================================= */
  Future<dynamic> get(String endpoint, {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Include token if available
    };

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}: ${response.body}'); // Throw error for other status codes
    }
  }
}