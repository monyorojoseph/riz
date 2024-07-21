import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';

class LandingPageLoader extends HookWidget {
  const LandingPageLoader({super.key});
  static const routeName = '/landingpageloader';

  @override
  Widget build(BuildContext context) {
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);
    useEffect(() {
      if (usersetting.data?.currentScreen == "CSCRN") {
        GoRouter.of(context).go(HomePage.routeName);
      }
      if (usersetting.data?.currentScreen == "SSCRN") {
        GoRouter.of(context).go(SellerHomePage.routeName);
      }
    }, [usersetting]);
    return const Scaffold(
      body: Center(
        child: Text("Acruda"),
      ),
    );
  }
}
