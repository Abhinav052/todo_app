import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todolist/services/auth_service.dart';
import 'package:todolist/utils/routes/routes.dart';
import 'package:todolist/utils/theme/app_pallete.dart';
import 'package:todolist/viewModel/auth_view_model.dart';
import 'package:todolist/views/components/custom_snackbar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isSubmitting = false;

  setSubmitting(bool value) {
    setState(() {
      isSubmitting = value;
    });
  }

  submitForm() async {
    setSubmitting(true);
    final res = await AuthService.login(
        identifier: emailController.text.trim(), password: passwordController.text.trim());
    res.fold((l) {
      snackBarCustom(context, l.message);
    }, (r) async {
      await Provider.of<AuthViewModel>(context, listen: false).login(r);
      Navigator.pushNamedAndRemoveUntil(context, Routes.homeScreen, (route) => false);
    });
    setSubmitting(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: isSubmitting,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Welcome Back!!",
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppPallete.primaryColor,
                            minimumSize: Size(MediaQuery.of(context).size.width * .5, 0),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              submitForm();
                            }
                          },
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                      color: AppPallete.surfaceColor, fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New here? ",
                              style: GoogleFonts.poppins(color: Colors.black),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.registerScreen, (route) => false);
                                },
                                child: Text(
                                  "Signup",
                                  style: GoogleFonts.poppins(
                                      color: AppPallete.primaryColor, fontWeight: FontWeight.bold),
                                ))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
