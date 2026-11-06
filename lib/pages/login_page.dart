
import 'package:flutter/material.dart';
import 'package:babyshophub/pages/signup_page.dart';
import 'package:babyshophub/pages/welcome_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:babyshophub/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Login to Continue.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 26),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    final email = (value ?? '').trim();

                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!EmailValidator.validate(email)) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 26),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }

                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? errorMessage;

                        try {
                          final response = await http.post(
                            Uri.parse(
                              'http://127.0.0.1:5000/api/login',
                            ),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({

                              'email': _emailController.text.trim(),
                              'password': _passwordController.text,
                            }),
                          );

                          if (response.statusCode == 200) {
                            final Map<String, dynamic> data = jsonDecode(response.body);
                            final firstName = data['user']['name'];
                            final email = data['user']['email'];

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomePage(name: firstName, email: email,),
                              ),
                            );

                            return;
                          } else if (response.statusCode == 400) {
                            final Map<String, dynamic> data =
                                jsonDecode(response.body);

                            errorMessage = data['error']?.toString() ??
                                'Email or password required.';
                          } else if (response.statusCode == 401) {
                            final Map<String, dynamic> data =
                                jsonDecode(response.body);

                            errorMessage = data['error']?.toString() ??
                                'Invalid email or password.';
                          } else if (response.statusCode == 500) {
                            final Map<String, dynamic> data =
                                jsonDecode(response.body);

                            errorMessage = data['error']?.toString() ??
                                'A server error occurred.';
                          } else {
                            errorMessage =
                                'Login failed. Please try again later '
                                '(HTTP ${response.statusCode}).';
                          }
                        } on SocketException {
                          errorMessage =
                              'No internet connection or server is unreachable.';
                        } on HttpException {
                          errorMessage = 'Could not reach the login service.';
                        } on FormatException {
                          errorMessage =
                              'Received an invalid response from the server.';
                        } catch (e) {
                          errorMessage = 'An unexpected error occurred.';
                        }

                        if (errorMessage != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.redAccent,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create an Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}