import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/widgets/bottomnavbar/sellerbottomnavbar.dart';

class SellerHomePage extends HookWidget {
  const SellerHomePage({super.key});
  static const routeName = '/seller';

  @override
  Widget build(BuildContext context) {
    final user = useQuery(['userDetails'], getUserDetails);
    String? fullName = user.data?.fullName;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomAppBar(
          child: SellerBottomNavbarItems(
        currentTab: routeName,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateVehiclePage.routeName);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
          weight: 800,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        children: <Widget>[Text("Welcome back, $fullName")],
      ),
    );
  }
}
