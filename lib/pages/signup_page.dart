import 'package:flutter/material.dart';
import 'package:babyshophub/pages/login_page.dart';
import 'package:babyshophub/pages/welcome_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:babyshophub/theme/app_colors.dart';
import 'package:http/http.dart' as http; // to send http requests to flask jssonEncode converts signup details into JSON for the Flask API
import 'dart:convert';
import 'dart:io'; // for socket and http exceptions


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
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
                Text(
                  'BabyShop Hub',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Create an Account to Continue.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                SizedBox(height: 26),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    final name = (value ?? '').trim();

                    if (name.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.perm_contact_calendar_outlined),
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 26,),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    final email = (value ?? '').trim();

                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!EmailValidator.validate(email)) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 26),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }

                    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must be at least 8 characters with letters and numbers';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 26),
                  SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                       if (_formKey.currentState!.validate()) {
                       String trimmedName = _nameController.text.trim(); 
                       String trimmedEmail = _emailController.text.trim(); 

                        String? errorMessage;

                        try {
                          final response = await http.post(
                            Uri.parse('http://127.0.0.1:5000/api/signup'),// changed based on device
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({
                              'first_name':trimmedName,
                              'email':_emailController.text,
                              'password':_passwordController.text
                            }),
                          );
                          if (response.statusCode == 201) {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomePage(name: trimmedName, email: trimmedEmail,), // passing in the trimmedName variable
                              ),
                            );
                            return;
                          } else if (response.statusCode == 400) {
                            Map<String, dynamic> data = jsonDecode(response.body);
                            errorMessage = data['error']?.toString() ?? 'An unknown error occurred.';
                          } else {
                            errorMessage = 'Something went wrong. Please try again later';
                          }
                        } on SocketException catch (_) {
                          errorMessage = 'No internet connection or server is unreachable.';
                        } on HttpException catch (_) {
                          errorMessage = 'Could not reach the signup service.';
                        } on FormatException catch (_) {
                          errorMessage = 'Received bad formatting from the server.';
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
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  child: Text(
                    "Already have an account? Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: AppColors.secondary,
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