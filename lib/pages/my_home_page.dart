import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/repositories/secure_storage_repositor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/utils.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userID = '';
  String userName = '';
  bool isLoggedIn = false;
  bool isLoading = false;
  late StreamSubscription<AuthState> _authStateChangesSubscription;

  StreamSubscription<AuthState> getAuthStateSubscription() {
    return Supabase.instance.client.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn) {
        final userData = state.session!.user;

        setState(() {
          isLoggedIn = true;
          userID = userData.id;
          userName = userData.userMetadata!['username'];
        });
      } else if (state.event == AuthChangeEvent.signedOut) {
        setState(() {
          isLoggedIn = false;
          userID = '';
          userName = '';
        });
      }
    });
  }

  @override
  void initState() {
    _authStateChangesSubscription = getAuthStateSubscription();
    super.initState();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'userID:$userID',
                  ),
                  Text(
                    'user name:$userName',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton.extended(
              onPressed: () => callOutAccessToken(),
              label: const Text('Logout'),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              label: const Text('Login'),
            ),
    );
  }

  Future<void> callOutAccessToken() async {
    await SecureStorageRepository.getAccessToken().then(
      (value) => print('get access token $value'),
    );
  }

  Future<void> _logout() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Supabase.instance.client.auth.signOut();
    } on AuthException catch (error) {
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (error) {
      showErrorSnackBar(context, message: error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
