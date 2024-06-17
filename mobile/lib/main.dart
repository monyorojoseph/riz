import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/register.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/pages/home/home.dart';
import 'package:mobile/utils/storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _storage = MyCustomSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riz',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        ...FormBuilderLocalizations.supportedLocales
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black12),
        useMaterial3: true,
      ),
      // initialRoute: LoginPage.routeName,
      onGenerateInitialRoutes: _onGenerateInitialRoutes,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        AuthVerificationPage.routeName: (context) =>
            const AuthVerificationPage(),
      },
    );
  }

  List<Route<dynamic>> _onGenerateInitialRoutes(String initialRoute) {
    // Implement your logic here to determine initial routes
    return [
      MaterialPageRoute(builder: (_) => _getInitialPage()),
    ];
  }

  Widget _getInitialPage() {
    // Implement logic to determine initial page based on tokens
    return FutureBuilder<Map<String, String>>(
      future: _storage.readAll(), // Fetch all stored values (tokens)
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // const CircularProgressIndicator(); // Show loading indicator while fetching tokens
          return const Scaffold(body: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Scaffold(
              body: Text(
                  'Error: ${snapshot.error}')); // Handle error if fetching fails
        }
        final tokens = snapshot.data;
        if (tokens != null &&
            tokens.containsKey('accessToken') &&
            tokens.containsKey('refreshToken')) {
          // Tokens are available, navigate to Home page
          return HomePage(); // Replace with logic based on tokens if needed
        } else {
          // Tokens are not available or invalid, navigate to Login page
          return const LoginPage(); // Replace with logic based on tokens if needed
        }
      },
    );
  }
}
