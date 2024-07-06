import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/pages/account/editprofile.dart';
import 'package:mobile/pages/account/listvehicle.dart';
import 'package:mobile/pages/account/usersettings.dart';
import 'package:mobile/pages/account/verification.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/register.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/pages/home/home.dart';
import 'package:mobile/pages/loaders/mainpage.dart';
import 'package:mobile/pages/loaders/switchpage.dart';
import 'package:mobile/pages/notifications/notifications.dart';
import 'package:mobile/pages/seller/calendar.dart';
import 'package:mobile/pages/seller/home.dart';
import 'package:mobile/pages/seller/menu.dart';
import 'package:mobile/pages/seller/notifications.dart';
import 'package:mobile/pages/seller/vehicle/create/create.dart';
import 'package:mobile/pages/seller/vehicle/edit/editvehicle.dart';
import 'package:mobile/utils/storage.dart';

import 'pages/account/account.dart';
import 'pages/history/history.dart';

final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);
void main() {
  runApp(QueryClientProvider(queryClient: queryClient, child: MyApp()));
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
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        bottomAppBarTheme: const BottomAppBarTheme(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black54,
            color: Colors.white),
        tabBarTheme: const TabBarTheme(
            labelColor: Colors.black, indicatorColor: Colors.black),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.black,
          labelStyle: TextStyle(color: Colors.black),
          floatingLabelStyle: TextStyle(color: Colors.black),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // initialRoute: LoginPage.routeName,
      onGenerateInitialRoutes: _onGenerateInitialRoutes,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        AuthVerificationPage.routeName: (context) =>
            const AuthVerificationPage(),
        AccountPage.routeName: (context) => const AccountPage(),
        HistoryPage.routeName: (context) => const HistoryPage(),
        NotificationsPage.routeName: (context) => const NotificationsPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        UserVerificationPage.routeName: (context) =>
            const UserVerificationPage(),
        UserSettingsPage.routeName: (context) => const UserSettingsPage(),
        UserListVehiclePage.routeName: (context) => const UserListVehiclePage(),
        // loaders
        MainLoaderPage.routeName: (context) => const MainLoaderPage(),
        SwitchLoaderPage.routeName: (context) => const SwitchLoaderPage(),
        // seller pages
        SellerHomePage.routeName: (context) => const SellerHomePage(),
        SellerCalendarPage.routeName: (context) => const SellerCalendarPage(),
        SellerMenuPage.routeName: (context) => const SellerMenuPage(),
        SellerNotificationPage.routeName: (context) =>
            const SellerNotificationPage(),
        CreateVehiclePage.routeName: (context) => const CreateVehiclePage(),
        EditVehiclePage.routeName: (context) => const EditVehiclePage()
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
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
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
          // return const HomePage(); // Replace with logic based on tokens if needed
          return const MainLoaderPage();
        } else {
          // Tokens are not available or invalid, navigate to Login page
          return const LoginPage(); // Replace with logic based on tokens if needed
        }
      },
    );
  }
}
