import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/user.dart';
import 'package:acruda/services/user.dart';

class UserListVehiclePage extends HookWidget {
  const UserListVehiclePage({super.key});
  static const routeName = '/userListVehicle';

  @override
  Widget build(BuildContext context) {
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);

    return Scaffold(
      appBar: AppBar(
        title: const Text("List vehicle"),
      ),
      body: usersetting.data?.appPurpose == "CLT"
          ? const ListVehicleActivate()
          : const ListVehiclePreview(),
    );
  }
}

// activate list vehicle
class ListVehicleActivate extends HookWidget {
  const ListVehicleActivate({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final queryClient = useQueryClient();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      children: <Widget>[
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          color: Colors.black,
          onPressed: () async {
            try {
              isLoading.value = true;
              UserSetting updatedUserSetting = await updateUserSettingDetails(
                  const UpdateUserSetting(appPurpose: "SLR"));
              if (updatedUserSetting.appPurpose == "SLR") {
                queryClient.setQueryData<UserSetting>(
                    ['userSettingDetails'], (previous) => updatedUserSetting);
              }
            } catch (e) {
              debugPrint('user setting failed to update: $e');
            } finally {
              isLoading.value = false;
            }
          },
          child: const Text(
            'Start Listing',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

// list vehicle preview
class ListVehiclePreview extends HookWidget {
  const ListVehiclePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[],
    );
  }
}
