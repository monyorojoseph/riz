import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fquery/fquery.dart';
import 'package:acruda/classes/pageargs/editvehicle.dart';
import 'package:acruda/classes/utils.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/pages/seller/vehicle/create/create.dart';
import 'package:acruda/pages/seller/vehicle/edit/editvehicle.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/user.dart';
import 'package:acruda/services/utils.dart';
import 'package:acruda/services/vehicle.dart';
import 'package:go_router/go_router.dart';

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
        centerTitle: false,
        title: Text(
          "Welcome back, $fullName",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context)
              .go(CreateVehiclePage.routeName, extra: CreateVehiclePageArgs());
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
        children: const <Widget>[MyListings()],
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
              "Your Listings",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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

class VehicleListing extends HookWidget {
  final Vehicle vehicle;
  const VehicleListing({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();
    final controller = useAnimationController();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: Slidable(
        key: ValueKey(vehicle.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: <Widget>[
            SlidableAction(
              onPressed: (BuildContext context) async {
                final response = await appService.genericGet(
                    true, '$baseUrl/vehicle/${vehicle.id}/enable-display');
                if (response.statusCode == 200) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your vehicle is visible to the public'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    final msg = ErrorMessage.fromJson(
                        jsonDecode(response.body) as Map<String, dynamic>);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Update failed: ${msg.detail} to enable display.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.remove_red_eye,
              label: "Display",
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                                "Are you sure you want to remove ${vehicle.brand.name} ${vehicle.model.name}"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("No")),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                    onPressed: () async {
                                      final response =
                                          await appService.genericDelete(
                                              '$baseUrl/vehicle/${vehicle.id}/delete');
                                      if (response.statusCode == 200) {
                                        queryClient
                                            .invalidateQueries(['myListings']);

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vehicle has been removed.'),
                                            ),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Failed to remove Vehicle.'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text("Yes")),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            )
          ],
        ),
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).go(EditVehiclePage.routeName,
                extra: EditVehiclePageArgs(vehicle.id));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: vehicle.display
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
                      '${vehicle.brand.name}  ${vehicle.model.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Text(
                      vehicle.yom.toString(),
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
