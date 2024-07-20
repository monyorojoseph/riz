import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acruda/pages/account/editprofile.dart';
import 'package:acruda/pages/account/listvehicle.dart';
import 'package:acruda/pages/account/usersettings.dart';
import 'package:acruda/pages/account/verification.dart';
import 'package:acruda/pages/auth/login.dart';
import 'package:acruda/pages/auth/register.dart';
import 'package:acruda/pages/auth/verification.dart';
import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/loaders/mainpage.dart';
import 'package:acruda/pages/loaders/switchpage.dart';
import 'package:acruda/pages/notifications/notifications.dart';
import 'package:acruda/pages/seller/calendar.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/pages/seller/menu.dart';
import 'package:acruda/pages/seller/notifications.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
import 'package:acruda/pages/seller/vehicle/edit/editvehicle.dart';
import 'package:acruda/utils/storage.dart';

import 'pages/account/account.dart';
import 'pages/history/history.dart';

final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);
void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/UFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
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
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            // foregroundColor: Colors.white,
            surfaceTintColor: Colors.white),
        bottomAppBarTheme: const BottomAppBarTheme(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black54,
            color: Colors.white),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.black,
          labelStyle: TextStyle(color: Colors.black),
          floatingLabelStyle: TextStyle(color: Colors.black),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black, // border color when focused
              width: 2.0,
            ),
          ),
        ),
        textTheme: GoogleFonts.ubuntuTextTheme(
          ThemeData.light().textTheme,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // initialRoute: HomePage.routeName,
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
          // debugPrint("[ TOKENS AVAILABLE ]");
          return const MainLoaderPage();
        } else {
          // Tokens are not available or invalid, navigate to Login page
          return const LoginPage(); // Replace with logic based on tokens if needed
        }
      },
    );
  }
}
