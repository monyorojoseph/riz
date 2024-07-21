import 'package:acruda/classes/pageargs/authverification.dart';
import 'package:acruda/classes/pageargs/editvehicle.dart';
import 'package:acruda/pages/landing/landingpage.dart';
import 'package:acruda/pages/landing/landingpageloader.dart';
import 'package:acruda/utils/storage.dart';
import 'package:acruda/widgets/customscaffolds/clientnavbarscaffold.dart';
import 'package:acruda/widgets/customscaffolds/sellernavbarscaffold.dart';
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
import 'package:acruda/pages/loaders/switchpage.dart';
import 'package:acruda/pages/notifications/notifications.dart';
import 'package:acruda/pages/seller/calendar.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/pages/seller/menu.dart';
import 'package:acruda/pages/seller/notifications.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
import 'package:acruda/pages/seller/vehicle/edit/editvehicle.dart';
import 'package:go_router/go_router.dart';

import 'pages/account/account.dart';
import 'pages/history/history.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _clientshellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'clientshell');
final GlobalKey<NavigatorState> _sellershellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sellershell');

final _queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);

final _storage = MyCustomSecureStorage();

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/UFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(QueryClientProvider(queryClient: _queryClient, child: MyApp()));
}

Future<Map<String, String>> _readStorageValues() async {
  try {
    return await _storage.readAll();
  } catch (error) {
    return {}; // Return an empty map on error
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: LandingPageLoader.routeName,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final storageValues = await _readStorageValues();
      if (storageValues.containsKey('accessToken') &&
          storageValues.containsKey('refreshToken')) {
        return state.uri.path;
      } else {
        final routes = [
          LoginPage.routeName,
          RegisterPage.routeName,
          AuthVerificationPage.routeName
        ];
        if (routes.contains(state.fullPath)) {
          return state.fullPath;
        }

        return LandingPage.routeName;
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: LandingPageLoader.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LandingPageLoader();
        },
      ),
      GoRoute(
        path: LandingPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LandingPage();
        },
      ),

      GoRoute(
        path: LoginPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),

      GoRoute(
        path: RegisterPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),

      GoRoute(
        path: AuthVerificationPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as AuthVerificationPageArgs;
          return AuthVerificationPage(args: args);
        },
      ),

      /// Client Application shell
      ShellRoute(
        navigatorKey: _clientshellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldClientNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: HomePage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: HistoryPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const HistoryPage();
            },
          ),
          GoRoute(
            path: NotificationsPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const NotificationsPage();
            },
          ),
          GoRoute(
            path: AccountPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const AccountPage();
            },
          ),
        ],
      ),

      // Seller Application shell
      ShellRoute(
        navigatorKey: _sellershellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScaffoldSellerNavBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: SellerHomePage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const SellerHomePage();
            },
          ),
          GoRoute(
            path: SellerCalendarPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const SellerCalendarPage();
            },
          ),
          GoRoute(
            path: SellerNotificationPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const SellerNotificationPage();
            },
          ),
          GoRoute(
            path: SellerMenuPage.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const SellerMenuPage();
            },
          ),
        ],
      ),

      // /// other routes
      GoRoute(
        path: ProfilePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),

      GoRoute(
        path: UserVerificationPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UserVerificationPage();
        },
      ),

      GoRoute(
        path: UserSettingsPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UserSettingsPage();
        },
      ),

      GoRoute(
        path: UserListVehiclePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const UserListVehiclePage();
        },
      ),
      GoRoute(
        path: SwitchLoaderPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as SwitchLoaderPageArgs;
          return SwitchLoaderPage(args: args);
        },
      ),

      GoRoute(
        path: CreateVehiclePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as CreateVehiclePageArgs?;
          return CreateVehiclePage(args: args);
        },
      ),
      GoRoute(
        path: EditVehiclePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as EditVehiclePageArgs;
          return EditVehiclePage(args: args);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Acruda',
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
          surfaceTintColor: Colors.white,
        ),
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
              color: Colors.black,
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
      routerConfig: _router,
    );
  }
}
