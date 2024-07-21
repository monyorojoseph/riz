import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:acruda/classes/vehicle.dart';
import 'package:acruda/services/url.dart';
import 'package:acruda/services/utils.dart';

class VehicleImagesForm extends HookWidget {
  final Vehicle vehicle;
  VehicleImagesForm({super.key, required this.vehicle});
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();
    final isLoading = useState<bool>(false);
    final pickedFiles = useState<List<XFile>?>([]);

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              color: Colors.black54,
              onPressed: () async {
                final List<XFile> images = await picker.pickMultiImage();
                if (images.isNotEmpty == true) {
                  pickedFiles.value = images;
                }
              },
              child: const Text(
                "Upload Images",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            if (pickedFiles.value?.isNotEmpty == true)
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                color: Colors.black,
                onPressed: () async {
                  if (pickedFiles.value?.isNotEmpty ?? false) {
                    String? vId = vehicle.id;
                    isLoading.value = true;
                    String url = '$baseUrl/vehicle-images/$vId/create';
                    StreamedResponse streamResponse =
                        await appService.uploadImages(url, pickedFiles.value!);
                    isLoading.value = false;

                    if (streamResponse.statusCode == 200) {
                      queryClient
                          .invalidateQueries(['${vehicle.id}-vehicle-images']);
                    } else {
                      throw Exception("Failed to upload images");
                    }
                  } else {
                    debugPrint("No Images");
                  }
                },
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
    );
  }
}
