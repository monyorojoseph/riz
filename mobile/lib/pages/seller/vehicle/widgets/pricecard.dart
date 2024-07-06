import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/classes/pricing.dart';
import 'package:mobile/constants/pricing.dart';

class PriceCard extends HookWidget {
  final Pricing price;
  const PriceCard({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final rentaltype =
        pricingPeriodTypes.firstWhere((tp) => tp['value'] == price.period);

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
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
