import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';

class Landingpage extends HookWidget {
  const Landingpage({super.key});
  static const routeName = '/landingpage';

  @override
  Widget build(BuildContext context) {
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);
    useEffect(() {
      if (usersetting.data?.currentScreen.isNotEmpty == true) {
        GoRouter.of(context).go(SellerHomePage.routeName);
      }
    }, [usersetting]);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
