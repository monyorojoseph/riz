// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:http/http.dart';
// import 'package:image_field/image_field.dart';
// import 'package:image_field/linear_progress_indicator_if.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:acruda/classes/vehicle.dart';
// import 'package:acruda/services/url.dart';
// import 'package:acruda/services/utils.dart';

// class VehicleImagesForm extends HookWidget {
//   final Vehicle vehicle;
//   VehicleImagesForm({super.key, required this.vehicle});
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final isLoading = useState<bool>(false);
//     final pickedFiles = useState<List<XFile>?>([]);
//     final remoteFiles = useState<List<ImageAndCaptionModel>?>([]);

//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           children: <Widget>[
//             ImageField(
//               onUpload: (dynamic pickedFile,
//                   ControllerLinearProgressIndicatorIF?
//                       controllerLinearProgressIndicator) async {
//                 pickedFiles.value = pickedFile;
//               },
//               files: remoteFiles.value != null
//                   ? remoteFiles.value!.map((image) {
//                       return ImageAndCaptionModel(file: image, caption: "");
//                     }).toList()
//                   : [],
//               onSave: (List<ImageAndCaptionModel>? imageAndCaptionList) {
//                 remoteFiles.value = imageAndCaptionList;
//               },
//               enabledCaption: false,
//               multipleUpload: true,
//             ),
//             const SizedBox(height: 10),
//             MaterialButton(
//               minWidth: MediaQuery.of(context).size.width,
//               padding: const EdgeInsets.symmetric(vertical: 7.5),
//               color: Colors.black,
//               onPressed: () async {
//                 if (pickedFiles.value?.isNotEmpty ?? false) {
//                   String? vId = vehicle.id;
//                   isLoading.value = true;
//                   String url = '$baseUrl/vehicle-images/$vId/create';
//                   StreamedResponse streamResponse =
//                       await appService.uploadImages(url, pickedFiles.value!);
//                   isLoading.value = false;

//                   if (streamResponse.statusCode == 200) {
//                     // print(streamResponse.stream.first.toString());
//                     // currentPage.value = CreateSteps.rates;
//                   } else {
//                     throw Exception("Failed to upload images");
//                   }
//                 } else {
//                   debugPrint("No Images");
//                 }
//               },
//               child: Text(
//                 isLoading.value ? "Saving" : 'Save',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
