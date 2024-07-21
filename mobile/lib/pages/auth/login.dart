import 'package:acruda/pages/account/verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:acruda/classes/auth.dart';
import 'package:acruda/classes/pageargs/authverification.dart';
import 'package:acruda/pages/auth/register.dart';
import 'package:acruda/pages/auth/verification.dart';
import 'package:acruda/services/auth.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

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
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("Hi welcome back"),
                ],
              ),
              const SizedBox(height: 20),
              LoginForm()
            ],
          ),
        ),
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
    final isLoading = useState(false);

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
                  String email = formData['email'];
                  String password = formData['password'];
                  try {
                    isLoading.value = true;
                    LoginUser user = await loginUser(email, password);
                    if (user.email.isNotEmpty && user.fullName.isNotEmpty) {
                      if (context.mounted) {
                        debugPrint(user.fullName);
                        GoRouter.of(context).go(AuthVerificationPage.routeName,
                            extra: AuthVerificationPageArgs(
                                user.email, user.fullName));
                      }
                    }
                  } catch (e) {
                    debugPrint('Login failed: $e');
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
                    'Login',
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
              const Text("Don't have an account ?"),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).go(RegisterPage.routeName);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
