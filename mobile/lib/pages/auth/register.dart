import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:acruda/classes/auth.dart';
import 'package:acruda/classes/pageargs/authverification.dart';
import 'package:acruda/pages/auth/login.dart';
import 'package:acruda/pages/auth/verification.dart';
import 'package:acruda/services/auth.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Container(
    //     color: Colors.white,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             const Center(
    //               child: Text("Create Account"),
    //             ),
    //             const SizedBox(height: 50),
    //             RegisterForm(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Create Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("Fill your information below"),
                ],
              ),
              const SizedBox(height: 20),
              RegisterForm()
            ],
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
          Row(
            children: <Widget>[
              const Text("Agree with ?"),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(LoginPage.routeName);
                  },
                  child: const Text(
                    "Terms & Conditions",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ))
            ],
          ),
          const SizedBox(height: 30),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            color: Colors.black,
            onPressed: () async {
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
                        GoRouter.of(context).go(AuthVerificationPage.routeName,
                            extra: AuthVerificationPageArgs(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Already have an account ?"),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(LoginPage.routeName);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
