import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/utils/storage.dart';

class AuthVerificationPage extends StatelessWidget {
  const AuthVerificationPage({super.key});
  static const routeName = '/authVerification';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AuthVerificationPageArgs;
    String fullName = args.fullName;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Token Auth Verification"),
                const SizedBox(height: 10),
                Text(
                    "$fullName Auth token has been sent to your email, use it to login."),
                AuthVerificationForm(email: args.email)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthVerificationForm extends HookWidget {
  final String email;
  AuthVerificationForm({super.key, required this.email});

  final _formKey = GlobalKey<FormBuilderState>();
  final _storage = MyCustomSecureStorage();
  // final GlobalKey<_AuthVerificationFormState> myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'token',
            decoration: const InputDecoration(labelText: 'Token'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 30),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                // final context = myWidgetKey.currentContext;
                final formData = _formKey.currentState?.value;

                if (formData != null) {
                  String token = formData['token'];
                  try {
                    AuthenticatedUser user = await getAuthTokens(token);
                    if (user.refresh.isNotEmpty && user.access.isNotEmpty) {
                      // save tokens
                      await _storage.write(
                          key: "refreshToken", value: user.refresh);
                      await _storage.write(
                          key: "accessToken", value: user.access);

                      Map<String, String> allValues = await _storage.readAll();
                      debugPrint(allValues.toString());

                      if (context.mounted) {
                        Navigator.pushNamed(context, '/');
                      }
                    }
                  } catch (e) {
                    debugPrint('Token Verifition failed: $e');
                  }
                }
              } else {
                debugPrint('Validation failed');
              }
            },
            child: const Text(
              'Submit',
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
