import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/user.dart';
import 'package:acruda/pages/home/home.dart';
import 'package:acruda/pages/seller/home.dart';
import 'package:acruda/services/user.dart';
import 'package:go_router/go_router.dart';

class SwitchLoaderPage extends HookWidget {
  final SwitchLoaderPageArgs args;
  const SwitchLoaderPage({super.key, required this.args});
  static const routeName = '/pageSwicher';

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    useEffect(() {
      void updateUserSettingOnLoad() async {
        final usersetting = await updateUserSettingDetails(
            UpdateUserSetting(currentScreen: args.currentScreen));

        queryClient.setQueryData<UserSetting>(
            ['userSettingDetails'], (previous) => usersetting);

        if (context.mounted) {
          if (usersetting.currentScreen == "CSCRN") {
            GoRouter.of(context).go(HomePage.routeName);
          }

          if (usersetting.currentScreen == "SSCRN") {
            GoRouter.of(context).go(SellerHomePage.routeName);
          }
        }
      }

      updateUserSettingOnLoad();
      return () {};
    }, []);
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

class SwitchLoaderPageArgs {
  final String currentScreen;

  SwitchLoaderPageArgs(this.currentScreen);
}
