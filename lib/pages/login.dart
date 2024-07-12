import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutricare/firebasestuff/authentication.dart';
import 'package:nutricare/randomutilities/text_field_input.dart';

import '../randomutilities/errordisplay.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'success') {
      Navigator.pushReplacementNamed(context, '/Home');
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/Signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 2),
                  //image
                  SvgPicture.asset('assets/starrytransmission.svg',
                      height: 145),
                  const SizedBox(height: 64),
                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(height: 24),
                  //text field input for password
                  TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      textInputType: TextInputType.text,
                      isPass: true),
                  const SizedBox(height: 24),
                  //button login
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: Colors.blue),
                      child: _isLoading
                          ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                          : const Text('Log in'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 2),

                  //transition to signing up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Don't have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Sign up.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ))),
    );
  }
}
