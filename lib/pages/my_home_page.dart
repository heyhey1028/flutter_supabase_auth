import 'dart:async';

import 'package:flutter/material.dart';
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

  // Create a function that returns a StreamSubscription of AuthState
  StreamSubscription<AuthState> getAuthStateSubscription() {
    // Listen to the onAuthStateChange stream and return the state
    return Supabase.instance.client.auth.onAuthStateChange.listen((state) {
      // If the user is signed in, update the state with their details
      if (state.event == AuthChangeEvent.signedIn) {
        final userData = state.session!.user;
        setState(() {
          isLoggedIn = true;
          userID = userData.id;
          userName = userData.userMetadata!['username'];
        });
        // If the user is signed out, reset the state
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
              onPressed: () => _logout(),
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

  /// Logs out the current user.
  ///
  /// If the logout process fails, the user is shown a snackbar with the error.
  ///
  /// If the logout process succeeds, the user is taken to the login screen.
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
