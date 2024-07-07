import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/classes/pricing.dart';
import 'package:mobile/constants/pricing.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/utils.dart';

class PriceCard extends HookWidget {
  final Pricing price;
  const PriceCard({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    final rentaltype =
        pricingPeriodTypes.firstWhere((tp) => tp['value'] == price.period);

    // handle delete
    Future<void> removePriceRate() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Are you sure you want to delete !"),
        action: SnackBarAction(
            label: "Confirm",
            onPressed: () async {
              final response = await appService
                  .genericDelete('$baseUrl/vehicle-pricing/${price.id}');

              if (response.statusCode == 200) {
                // remove it manually from use query

                queryClient.setQueryData<List<Pricing>>(
                    ['vehicle-pricings-${price.vehicle}'], (previous) {
                  return previous
                          ?.where((element) => element.id != price.id)
                          .toList() ??
                      <Pricing>[];
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Removed")));
                }
              } else {
                throw Exception('Failed to delete.');
              }
            }),
      ));
    }

    // handle edit

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(rentaltype['label'].toString()),
              const SizedBox(
                height: 5,
              ),
              Text('${price.amount.toString()} ksh'),
            ],
          ),
          Row(
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {},
              //   child: const Icon(
              //     Icons.edit,
              //     color: Colors.blue,
              //   ),
              // ),
              GestureDetector(
                onTap: removePriceRate,
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
