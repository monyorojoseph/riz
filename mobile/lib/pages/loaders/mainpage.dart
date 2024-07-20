import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/services/user.dart';

class MainLoaderPage extends HookWidget {
  const MainLoaderPage({super.key});
  static const routeName = '/mainPageLoader';

  @override
  Widget build(BuildContext context) {
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);

    // if (usersetting.isError) {
    //   debugPrint(usersetting.error.toString());
    // }

    // Use useEffect to perform side-effects (like navigation) when usersetting changes
    useEffect(() {
      if (usersetting.data?.currentScreen == "CSCRN") {
        navigateToHomePage(context);
      } else if (usersetting.data?.currentScreen == "SSCRN") {
        navigateToSellerHomePage(context);
      }
      return null;
    }, [usersetting]);

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void navigateToHomePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return const HomePage();
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  void navigateToSellerHomePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return const SellerHomePage();
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }
}
