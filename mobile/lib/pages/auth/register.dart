import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/services/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[const Text("Register Form"), RegisterForm()],
      ),
    );
  }
}

class RegisterForm extends HookWidget {
  RegisterForm({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'fullName',
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            // key: _emailFieldKey,
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
              // _formKey.currentState?.saveAndValidate();
              // debugPrint(_formKey.currentState?.value.toString());

              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formData = _formKey.currentState?.value;
                if (formData != null) {
                  String fullName = formData['fullName'];
                  String email = formData['email'];
                  String password = formData['password'];
                  try {
                    RegisterUser user =
                        await registerUser(email, password, fullName);
                    if (user.email.isNotEmpty && user.fullName.isNotEmpty) {
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context, AuthVerificationPage.routeName,
                            arguments: AuthVerificationPageArgs(
                                user.email, user.fullName));
                      }
                    }
                  } catch (e) {
                    debugPrint('Registration failed: $e');
                  }
                }
              } else {
                debugPrint('Validation failed');
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
