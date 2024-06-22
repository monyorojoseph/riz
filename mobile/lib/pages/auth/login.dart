import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mobile/classes/auth.dart';
import 'package:mobile/pages/auth/register.dart';
import 'package:mobile/pages/auth/verification.dart';
import 'package:mobile/services/auth.dart';

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
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text("Login"),
                ),
                const SizedBox(height: 50),
                LoginForm()
              ],
            ),
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
          isLoading.value
              ? const CircularProgressIndicator()
              : MaterialButton(
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
                          if (user.email.isNotEmpty &&
                              user.fullName.isNotEmpty) {
                            if (context.mounted) {
                              Navigator.pushNamed(
                                  context, AuthVerificationPage.routeName,
                                  arguments: AuthVerificationPageArgs(
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
                  child: const Text(
                    'Login',
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
              Navigator.pushNamed(context, RegisterPage.routeName);
            },
            child: const Text(
              "Create account ?",
              style: TextStyle(
                  decoration: TextDecoration.underline, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
