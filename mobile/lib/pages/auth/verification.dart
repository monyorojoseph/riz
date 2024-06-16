import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/utils/storage.dart';

class AuthVerificationPage extends StatelessWidget {
  const AuthVerificationPage({super.key});
  static const routeName = '/authVerification';

  @override
  Widget build(BuildContext context) {
    final _args =
        ModalRoute.of(context)!.settings.arguments as AuthVerificationPageArgs;

    return Scaffold(
      body: ListView(
        children: const <Widget>[Text("Login Form"), AuthVerificationForm()],
      ),
    );
  }
}

class AuthVerificationForm extends StatefulWidget {
  const AuthVerificationForm({super.key});

  @override
  State<AuthVerificationForm> createState() => _AuthVerificationFormState();
}

class _AuthVerificationFormState extends State<AuthVerificationForm> {
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
          MaterialButton(
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
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Future<AuthenticatedUser> getAuthTokens(String token) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/auth/token'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'token': token,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return AuthenticatedUser.fromJson(responseData);
  } else {
    throw Exception('Failed to verify your token');
  }
}

class AuthenticatedUser {
  final String refresh;
  final String access;
  final User user;

  const AuthenticatedUser(
      {required this.refresh, required this.access, required this.user});

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
        refresh: json['refresh'] as String,
        access: json['access'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>));
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final bool verifiedEmail;
  final bool verified;

  const User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.verifiedEmail,
      required this.verified});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      verifiedEmail: json['verifiedEmail'] as bool,
      verified: json['verified'] as bool,
    );
  }
}

class AuthVerificationPageArgs {
  final String email;
  final String fullName;

  AuthVerificationPageArgs(this.email, this.fullName);
}
