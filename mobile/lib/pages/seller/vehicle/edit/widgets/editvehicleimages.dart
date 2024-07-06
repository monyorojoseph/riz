import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:image_field/image_field.dart';
import 'package:image_field/linear_progress_indicator_if.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/classes/vehicle.dart';
import 'package:mobile/services/url.dart';
import 'package:mobile/services/vehicle.dart';

class EditVehicleImages extends HookWidget {
  final Vehicle vehicle;
  EditVehicleImages({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(false);
    final pickedFiles = useState<List<XFile>?>([]);
    final remoteFiles = useState<List<ImageAndCaptionModel>?>([]);

    final images = useQuery(
        ['${vehicle.id}-vehicle-images'], () => vehicleImages(vehicle.id));

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: images.data
                      ?.map((e) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.network('$baseUrl${e.image}'),
                          ))
                      .toList() ??
                  [],
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      ImageField(
                        onUpload: (dynamic pickedFile,
                            ControllerLinearProgressIndicatorIF?
                                controllerLinearProgressIndicator) async {
                          pickedFiles.value = pickedFile;
                        },
                        files: remoteFiles.value != null
                            ? remoteFiles.value!.map((image) {
                                return ImageAndCaptionModel(
                                    file: image, caption: "");
                              }).toList()
                            : [],
                        onSave:
                            (List<ImageAndCaptionModel>? imageAndCaptionList) {
                          remoteFiles.value = imageAndCaptionList;
                        },
                        enabledCaption: false,
                        multipleUpload: true,
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 7.5),
                        color: Colors.black,
                        onPressed: () async {},
                        child: Text(
                          isLoading.value ? "Saving" : 'Save',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
