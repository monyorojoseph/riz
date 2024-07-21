import 'package:acruda/pages/landing/landingpage.dart';
import 'package:acruda/services/user.dart';
import 'package:acruda/utils/storage.dart';
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
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

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

final _storage = MyCustomSecureStorage();

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
    initialLocation: Landingpage.routeName,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final storageValues = await _readStorageValues();

      if (storageValues.containsKey('accessToken') &&
          storageValues.containsKey('refreshToken')) {
        return state.uri.path;
      } else {
        return Landingpage.routeName;
      }
    },
    routes: <RouteBase>[
      GoRoute(
        path: Landingpage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const Landingpage();
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
          return const AuthVerificationPage();
        },
      ),

      /// Client Application shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
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
        navigatorKey: _shellNavigatorKey,
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
          return const SwitchLoaderPage();
        },
      ),

      GoRoute(
        path: CreateVehiclePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const CreateVehiclePage();
        },
      ),
      GoRoute(
        path: EditVehiclePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const EditVehiclePage();
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

class ScaffoldClientNavBar extends StatelessWidget {
  const ScaffoldClientNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == HomePage.routeName) {
      return 0;
    }
    if (location == HistoryPage.routeName) {
      return 1;
    }
    if (location == NotificationsPage.routeName) {
      return 2;
    }
    if (location == AccountPage.routeName) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(HomePage.routeName);
      case 1:
        GoRouter.of(context).go(HistoryPage.routeName);
      case 2:
        GoRouter.of(context).go(NotificationsPage.routeName);

      case 3:
        GoRouter.of(context).go(AccountPage.routeName);
    }
  }
}

class ScaffoldSellerNavBar extends StatelessWidget {
  const ScaffoldSellerNavBar({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == SellerHomePage.routeName) {
      return 0;
    }
    if (location == SellerCalendarPage.routeName) {
      return 1;
    }
    if (location == SellerNotificationPage.routeName) {
      return 2;
    }
    if (location == SellerMenuPage.routeName) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(SellerHomePage.routeName);
      case 1:
        GoRouter.of(context).go(SellerCalendarPage.routeName);
      case 2:
        GoRouter.of(context).go(SellerNotificationPage.routeName);

      case 3:
        GoRouter.of(context).go(SellerMenuPage.routeName);
    }
  }
}
