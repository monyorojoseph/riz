import 'package:acruda/pages/landing/landingpageloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:acruda/classes/auth.dart';
import 'package:acruda/classes/pageargs/authverification.dart';
import 'package:acruda/services/auth.dart';
import 'package:acruda/utils/storage.dart';
import 'package:go_router/go_router.dart';

class AuthVerificationPage extends StatelessWidget {
  final AuthVerificationPageArgs args;
  const AuthVerificationPage({super.key, required this.args});
  static const routeName = '/authVerification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Verify Code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Please enter the code we just sent to email"),
                  Text(args.email)
                ],
              ),
              const SizedBox(height: 20),
              AuthVerificationForm(email: args.email),
            ],
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
    final isLoading = useState(false);

    return SingleChildScrollView(
      child: FormBuilder(
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
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Didn't receive OTP ?"),
                TextButton(
                    onPressed: () {
                      // GoRouter.of(context).go(RegisterPage.routeName);
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ))
              ],
            ),
            const SizedBox(height: 10),
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
                      isLoading.value = true;
                      AuthenticatedUser user = await getAuthTokens(token);
                      if (user.refresh.isNotEmpty && user.access.isNotEmpty) {
                        // save tokens
                        await _storage.write(
                            key: "refreshToken", value: user.refresh);
                        await _storage.write(
                            key: "accessToken", value: user.access);

                        // Map<String, String> allValues =
                        //     await _storage.readAll();
                        // debugPrint(allValues.toString());
                        if (context.mounted) {
                          GoRouter.of(context).go(LandingPageLoader.routeName);
                        }
                      }
                    } catch (e) {
                      debugPrint('Token Verifition failed: $e');
                    } finally {
                      isLoading.value = false;
                    }
                  }
                } else {
                  debugPrint('Validation failed');
                }
              },
              child: isLoading.value
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Verify',
                      style: TextStyle(
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
