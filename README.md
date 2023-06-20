# flutter_supabase_auth
This is a sample project for using `Supabase Authentication` with Flutter.

# What is Supabase?

Supabase is an open source mBaaS intended alternate Firebase. It features a RelationalDataBase (RDB) based on **Postgres** and also offers a variety of features that are comparable to Firebase, including real-time updates, authentication, storage, and serverless functions.

The biggest difference between Firebase and Supabase is that Firebase is a NoSQL-based DB, while Supabase is an RDB-based DB. While many commercial services are based on RDBs, adopting Firebase required the cost of learning a new paradigm, NoSQL. But with Supabase, developers can easily construct an mobile infrastructure based on good old RDB that they are familiar with.

https://supabase.com/

# Steps for initializing Supabase
## 1. Create Supabase project
## 2. install package

```bash
flutter pub add supabase_flutter
```

https://pub.dev/packages/supabase_flutter

## 3. initialize Supabase on Flutter

You can find your `url` and `anonKey` from your project's setting.
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // add
  await Supabase.initialize( // add 
    url: 'https://<your_project_id>.supabase.co',
    anonKey: '<your_anon_key>',
  );
  runApp(const MyApp());
}
```

## 3. get Supabase client
All of the methods and properties provided by the package is accessed through this client class.
```dart
final supabase = Supabase.instance.client;
```

# How to use

## SignUp
Most simple example of signing up is done by passing email and password to **`Supabase.instance.client.auth.signUp()`** method.

if you want to register extra metadata, you can do it by passing `Map<String, dynamic>` data to `data` field.

```dart
  Future<void> _signUp({
    required String email,
    required String userName,
    required String password,
  }) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'user_name': userName}, // pass Map<String,dynamic> to register user metadata.
      );
    } on AuthException catch (error) {
      ...
    } on Exception catch (error) {
      ...
    }
  }
```

## SignIn
Signing in with email/password is done through **`Supabase.instance.client.auth.signInWithPassword()`** method.

It will return a `AuthResponse` class which contains `User` class and `Session` class.
```dart
  Future<void> _loginWithPassword({
    required String email,
    required String password,
  }) async {

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        ...
      }
    } on AuthException catch (error) {
      ...
    } on Exception catch (e) {
      ...
    } 
  }
```

### `AuthResponse`
```dart
class AuthResponse {
  final Session? session;
  final User? user;

  AuthResponse({
    this.session,
    User? user,
  }) : user = user ?? session?.user;

  /// Instanciates an `AuthResponse` object from json response.
  AuthResponse.fromJson(Map<String, dynamic> json)
      : session = Session.fromJson(json),
        user = User.fromJson(json) ?? Session.fromJson(json)?.user;
}
```
