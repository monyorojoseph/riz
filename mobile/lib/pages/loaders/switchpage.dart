import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/user.dart';
import 'package:mobile/pages/home/home.dart';
import 'package:mobile/pages/seller/home.dart';
import 'package:mobile/services/user.dart';

class SwitchLoaderPage extends HookWidget {
  const SwitchLoaderPage({super.key});
  static const routeName = '/pageSwicher';

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    final args =
        ModalRoute.of(context)!.settings.arguments as SwitchLoaderPageArgs;
    String currentScreen = args.currentScreen;

    useEffect(() {
      void updateUserSettingOnLoad() async {
        final usersetting = await updateUserSettingDetails(
            UpdateUserSetting(currentScreen: currentScreen));

        queryClient.setQueryData<UserSetting>(
            ['userSettingDetails'], (previous) => usersetting);

        if (context.mounted) {
          if (usersetting.currentScreen == "CLT") {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const HomePage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }

          if (usersetting.currentScreen == "SSCRN") {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return const SellerHomePage();
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
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
