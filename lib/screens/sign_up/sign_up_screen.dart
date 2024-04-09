import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/core/functions/validation.dart';
import 'package:train/data/model/user_model.dart';
import 'package:train/main.dart';
import 'package:train/screens/login/widgets/label.dart';
import 'package:train/widgets/form/input.dart';
import 'package:train/widgets/form/primary_button.dart';
import 'package:train/widgets/logo/logo.dart';
import 'package:train/widgets/snackbar/snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _loading = false;
  bool _disabled = false;
  bool _obscure = true;
  bool _confirmObscure = true;

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscure = _obscure ? false : true;
    });
  }

  void _toggleConfirmObscure() {
    setState(() {
      _confirmObscure = _confirmObscure ? false : true;
    });
  }

  Future<void> _register() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _loading = true;
          _disabled = true;
        });
        final res = await supabase.auth.signUp(
          email: _email.text,
          password: _password.text,
        );

        UserModel user = UserModel(
          id: res.user?.id,
          email: _email.text,
          name: _name.text,
          phone: int.parse(_phone.text),
        );
        await supabase.from('user').insert([user.toJson()]);
        setState(() {
          _loading = false;
          _disabled = false;
        });
        showSnackbar(
            context: context, message: "Sign-up successful. Please login.");
        _formKey.currentState!.reset();
        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      log("Error during sign-up: $e");

      showSnackbar(
          context: context,
          isError: true,
          message: "An error occurred during sign-up. Please try again.");

      setState(() {
        _loading = false;
        _disabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Center(child: Logo()),
            SizedBox(height: MediaQuery.sizeOf(context).height * .07),
            Text(
              "Register",
              style: Style.headline20.copyWith(
                  color: AppColor.backgroundColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 7),
            Text(
              "Create an account to get started.",
              style: Style.headline24.copyWith(
                  color: AppColor.accentColor, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .03),
            const Label("Name"),
            Input(
              hintText: "Name",
              controller: _name,
              validator: (value) => validName(value!),
            ),
            const Label("Email"),
            Input(
              hintText: "Email",
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => validEmail(value!),
            ),
            const Label("Phone"),
            Input(
              hintText: "Phone",
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: (value) => validPhone(value!),
            ),
            const Label("Password"),
            Input(
              hintText: "Password",
              controller: _password,
              obscure: _obscure,
              validator: (value) => validPassword(value!),
              suffixIcon: IconButton(
                onPressed: _toggleObscure,
                icon: Icon(
                  _obscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.greyLight,
                ),
              ),
            ),
            const Label("Confirm Password"),
            Input(
              hintText: "Confirm Password",
              controller: _confirmPassword,
              obscure: _confirmObscure,
              validator: (value) =>
                  validConfirmPassword(_password.text, value!),
              suffixIcon: IconButton(
                onPressed: _toggleConfirmObscure,
                icon: Icon(
                  _confirmObscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.greyLight,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .05),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                name: "Register",
                onPressed: _register,
                disabled: _disabled,
                loading: _loading,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Style.body14.copyWith(color: AppColor.white),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    "Login",
                    style: Style.body14.copyWith(
                      color: AppColor.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
