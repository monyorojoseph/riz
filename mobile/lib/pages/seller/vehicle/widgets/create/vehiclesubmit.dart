import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateVehicleLast extends HookWidget {
  final ValueNotifier<String> currentPage;
  const CreateVehicleLast({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          MaterialButton(
            // minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () {
              currentPage.value = "RATES";
            },
            child: const Text(
              'Back',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          MaterialButton(
            // minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () {},
            child: const Text(
              'Save',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    ]);
  }
}
