import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/utils.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';
import 'package:mobile/pages/seller/vehicle/editvehicle.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/services/utils.dart';
import 'package:mobile/services/vehicle.dart';
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
        children: <Widget>[
          Text("Welcome back, $fullName"),
          const SizedBox(height: 20),
          const MyListings(),
        ],
      ),
    );
  }
}

class MyListings extends HookWidget {
  const MyListings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Row(
          children: [
            Text(
              "My Listings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            )
          ],
        ),
        SizedBox(height: 20),
        VehicleListings()
      ],
    );
  }
}

class VehicleListings extends HookWidget {
  const VehicleListings({super.key});
  @override
  Widget build(BuildContext context) {
    final listings = useQuery(['myListings'], myListedtVehicleModels);
    debugPrint(listings.data?.length.toString());

    if (listings.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (listings.isError) {
      return Center(
        child: Text(listings.error.toString()),
      );
    }

    if (listings.data?.isEmpty ?? false) {
      return const Center(
        child: Text("You have no listings"),
      );
    }
    return Column(
      children: listings.data
              ?.map((vehicle) => VehicleListing(vehicle: vehicle))
              .toList() ??
          [],
    );
  }
}

class VehicleListing extends HookWidget {
  final Vehicle vehicle;
  const VehicleListing({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final bg = useState<Color>(
        vehicle.display ? Colors.white : Colors.black.withOpacity(0.05));
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, EditVehiclePage.routeName);
      },
      onLongPress: () async {
        bg.value = Colors.greenAccent;
        final response = await genericGet(
            true, 'http://127.0.0.1:8000/vehicle/${vehicle.id}/enable-display');
        if (response.statusCode == 200) {
          bg.value = Colors.white;

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your vehicle is visible to the public'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          bg.value = Colors.black.withOpacity(0.05);
          if (context.mounted) {
            final msg = ErrorMessage.fromJson(
                jsonDecode(response.body) as Map<String, dynamic>);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Update failed: ${msg.detail} to enable display.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      // onHorizontalDragStart: (details) {
      //   debugPrint(details.toString());
      //   debugPrint("Horiz");
      // },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg.value,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('${vehicle.brand.name}  ${vehicle.model.name}')
              ],
            ),
            Row(
              children: <Widget>[Text(vehicle.yom.toString())],
            ),
          ],
        ),
      ),
    );
  }
}
