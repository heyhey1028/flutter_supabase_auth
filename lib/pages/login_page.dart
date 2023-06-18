// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:flutter_supabase_auth/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/secure_storage_repositor.dart';
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
              const SizedBox(height: 24.0),
              const SocialLogins(),
              const SizedBox(height: 12.0),
              ElevatedButton(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await _loginWithPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (response == null || response.user == null) {
                      return;
                    }
                    print('access token:${response.session?.accessToken}');
                    await SecureStorageRepository.setAccessToken(
                        response.session?.accessToken ?? '');
                    Navigator.of(context).pop();
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

  Future<AuthResponse?> _loginWithPassword({
    required String email,
    required String password,
  }) async {
    setState(() {
      isLoading = true;
    });
    try {
      return await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (error) {
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (e) {
      showErrorSnackBar(context, message: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }
}

class SocialLogins extends StatelessWidget {
  const SocialLogins({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // google login
        FlutterSocialButton(
          buttonType: ButtonType.google,
          mini: true,
          onTap: () async {
            try {
              // final response = Supabase.instance.client.auth;
              // if (response.user != null) {
              //   Navigator.of(context).pop();
              // }
            } on AuthException catch (error) {
              showErrorSnackBar(context, message: error.message);
            } on Exception catch (e) {
              showErrorSnackBar(context, message: e.toString());
            }
          },
        ),
        const SizedBox(width: 16.0),
        // github login
        FlutterSocialButton(
          buttonType: ButtonType.github,
          mini: true,
          onTap: () async {
            try {
              // final response = await Supabase.instance.client.auth.signIn(provider: Provider.github);
              // if (response.user != null) {
              //   Navigator.of(context).pop();
              // }
            } on AuthException catch (error) {
              showErrorSnackBar(context, message: error.message);
            } on Exception catch (e) {
              showErrorSnackBar(context, message: e.toString());
            }
          },
        ),
        const SizedBox(width: 16.0),
        // twitter login
        FlutterSocialButton(
          buttonType: ButtonType.twitter,
          mini: true,
          onTap: () async {
            try {
              // final response = await Supabase.instance.client.auth.signIn(provider: Provider.twitter);
              // if (response.user != null) {
              //   Navigator.of(context).pop();
              // }
            } on AuthException catch (error) {
              showErrorSnackBar(context, message: error.message);
            } on Exception catch (e) {
              showErrorSnackBar(context, message: e.toString());
            }
          },
        ),
      ],
    );
  }
}
