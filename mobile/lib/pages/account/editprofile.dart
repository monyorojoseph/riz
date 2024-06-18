import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';
import 'package:mobile/services/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          children: <Widget>[
            const Text(
              "Your details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7.5),
            const Text(
                """You can edit your personal details here. When you're done tab "Save"""),
            const SizedBox(height: 15),
            ProfileForm(),
          ],
        ),
      ),
    );
  }
}

class ProfileForm extends HookWidget {
  ProfileForm({super.key});
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final user = useQuery(['userDetails'], getUserDetails);

    // final updateUserMutation = useMutation<UserDetails, Exception, UserDetails, UserDetails>(
    //   updateUserDetails,
    //   onMutate: (updatedUser) async {
    //     final previousUser = queryClient.getQueryData<UserDetails>(['userDetails']);

    //     queryClient.setQueryData<UserDetails>(['userDetails'], updatedUser);

    //     return previousUser;
    //   },
    //   onError: (err, updatedUser, previousUser) {
    //     queryClient.setQueryData<UserDetails>(['userDetails'], previousUser);
    //   },
    //   onSettled: (data, error, variables, ctx) {
    //     queryClient.invalidateQueries(['userDetails']);
    //   },
    // );

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'fullName',
            initialValue: user.data?.fullName,
            decoration: const InputDecoration(labelText: 'Full name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          FormBuilderTextField(
            name: 'email',
            initialValue: user.data?.email,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          FormBuilderTextField(
            name: 'phone',
            initialValue: user.data?.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: FormBuilderValidators.compose([]),
          ),
          FormBuilderRadioGroup(
            name: "sex",
            initialValue: user.data?.sex,
            decoration: const InputDecoration(labelText: 'Sex'),
            options: ['ML', 'FML', null]
                .map((v) => FormBuilderFieldOption(
                      value: v,
                      child: Text(v == "ML"
                          ? "Male"
                          : v == "FML"
                              ? "Female"
                              : "Prefer not to say"),
                    ))
                .toList(growable: false),
          ),
          const SizedBox(height: 30),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
              } else {
                debugPrint('Validation failed');
              }
            },
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
    );
  }
}
