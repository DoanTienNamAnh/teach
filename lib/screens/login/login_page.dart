import 'package:demo/gen/assets.gen.dart';
import 'package:demo/screens/login/register_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  void _login() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              title: Text("Success!"),
              content: Text("Login Success!"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.images.imgLoginBg.path),
                fit: BoxFit.fill),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "WELLCOME",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Gap(40),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1),
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.ac_unit,
                          size: 100,
                        ),
                        const Gap(40),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black45,
                            ),
                          ),
                          validator: (text) {
                            if (text?.isNotEmpty == true &&
                                EmailValidator.validate(text!)) {
                              return null;
                            } else {
                              return 'Email invalid!';
                            }
                          },
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black45,
                            ),
                            suffixIcon: Icon(
                              Icons.visibility,
                              color: Colors.black45,
                            ),
                          ),
                          validator: (text) {
                            if (text?.isNotEmpty == true && text!.length > 6) {
                              return null;
                            } else {
                              return 'Password invalid!';
                            }
                          },
                        ),
                        const Gap(32),
                        OutlinedButton(
                            style: const ButtonStyle(),
                            onPressed: _login,
                            child: const Text("Login")),
                        const Gap(40),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
