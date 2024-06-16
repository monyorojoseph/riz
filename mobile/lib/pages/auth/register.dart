import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/pages/auth/verification.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const <Widget>[Text("Login Form"), RegisterForm()],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
                    SlimUser user =
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

Future<SlimUser> registerUser(
    String email, String password, String fullName) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/registration'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
      'fullName': fullName,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return SlimUser.fromJson(responseData);
  } else {
    throw Exception('Failed to create an account.');
  }
}

class SlimUser {
  final String id;
  final String fullName;
  final String email;

  const SlimUser({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory SlimUser.fromJson(Map<String, dynamic> json) {
    return SlimUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
    );
  }
}
