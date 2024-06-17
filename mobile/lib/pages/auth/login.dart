import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/services/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[const Text("Login Form"), LoginForm()],
      ),
    );
  }
}

class LoginForm extends HookWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  // final GlobalKey<_LoginFormState> myWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(labelText: 'Email'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'password',
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          MaterialButton(
            color: Colors.black,
            onPressed: () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                // final context = myWidgetKey.currentContext;
                final formData = _formKey.currentState?.value;

                if (formData != null) {
                  String email = formData['email'];
                  String password = formData['password'];
                  try {
                    LoginUser user = await loginUser(email, password);
                    if (user.email.isNotEmpty && user.fullName.isNotEmpty) {
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context, AuthVerificationPage.routeName,
                            arguments: AuthVerificationPageArgs(
                                user.email, user.fullName));
                      }
                    }
                  } catch (e) {
                    debugPrint('Login failed: $e');
                  }
                }
              } else {
                debugPrint('Validation failed');
              }
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
