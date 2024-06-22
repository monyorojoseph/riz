import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/user.dart';
import 'package:mobile/services/user.dart';

class UserListVehiclePage extends HookWidget {
  const UserListVehiclePage({super.key});
  static const routeName = '/userListVehicle';

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();
    final usersetting = useQuery(['userSettingDetails'], getUserSettingDetails);
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("List vehicle"),
      ),
      body: ListView(
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
