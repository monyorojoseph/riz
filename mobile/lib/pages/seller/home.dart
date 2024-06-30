import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/pageargs/editvehicle.dart';
import 'package:mobile/classes/utils.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/pages/seller/vehicle/create.dart';
import 'package:mobile/pages/seller/vehicle/editvehicle.dart';
import 'package:mobile/services/url.dart';
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
          Navigator.pushNamed(context, CreateVehiclePage.routeName,
              arguments: CreateVehiclePageArgs());
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
    final listings = useQuery(['myListings'], myListedVehicles);

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

class VehicleListing extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleListing({super.key, required this.vehicle});
  @override
  State<VehicleListing> createState() => _VehicleListingState();
}

class _VehicleListingState extends State<VehicleListing>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: Slidable(
        key: ValueKey(widget.vehicle.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: <Widget>[
            SlidableAction(
              onPressed: (BuildContext context) {},
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.remove_red_eye,
              label: "Display",
            ),
            SlidableAction(
              onPressed: (BuildContext context) {},
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, EditVehiclePage.routeName,
                arguments: EditVehiclePageArgs(widget.vehicle.id));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: widget.vehicle.display
                  ? Colors.white
                  : Colors.black.withOpacity(0.05),
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
                    Text(
                      '${widget.vehicle.brand.name}  ${widget.vehicle.model.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Text(
                      widget.vehicle.yom.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
