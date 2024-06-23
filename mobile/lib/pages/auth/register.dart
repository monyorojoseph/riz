import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/pages/auth/login.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/services/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text("Create Account"),
                ),
                const SizedBox(height: 50),
                RegisterForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends HookWidget {
  RegisterForm({super.key});

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
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
          const SizedBox(height: 30),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
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
                    isLoading.value = true;
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
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
          ),
          const SizedBox(height: 20),
          const Text("or"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginPage.routeName);
            },
            child: const Text(
              "login",
              style: TextStyle(
                  decoration: TextDecoration.underline, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
