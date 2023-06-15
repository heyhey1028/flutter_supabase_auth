// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0), // Spacer(
              ElevatedButton(
                child: isLoading ? const CircularProgressIndicator() : const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginWithPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  }
                },
              ),
              TextButton(
                child: const Text('Go to Signup'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithPassword({
    required String email,
    required String password,
  }) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      if (response.user != null) {
        Navigator.of(context).pop();
      }
    } on AuthException catch (error) {
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (e) {
      showErrorSnackBar(context, message: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
