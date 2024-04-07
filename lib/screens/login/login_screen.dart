import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:train/core/cache/app_cache.dart';
import 'package:train/core/constants/app_color.dart';
import 'package:train/core/styles/style.dart';
import 'package:train/core/validation/validation.dart';
import 'package:train/main.dart';
import 'package:train/screens/login/widgets/label.dart';
import 'package:train/widgets/form/input.dart';
import 'package:train/widgets/form/primary_button.dart';
import 'package:train/widgets/logo/logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  bool _disabled = false;
  bool _obscure = true;
  final AppCache _cache = AppCache();

  @override
  void initState() {
    if (_cache.getIsLoggedIn() == true) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscure = _obscure ? false : true;
    });
  }

  Future<void> _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _loading = true;
          _disabled = true;
        });
        await supabase.auth.signInWithPassword(
          email: _email.text,
          password: _password.text,
        );

        setState(() {
          _loading = false;
          _disabled = false;
        });

        _formKey.currentState!.reset();
        _cache.setIsLoggedIn(true);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      log("Error during resgiter: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error during login. Please try again later."),
        ),
      );
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
              "Login",
              style: Style.headline20.copyWith(
                  color: AppColor.backgroundColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 7),
            Text(
              "Welcome back!",
              style: Style.headline24.copyWith(
                  color: AppColor.accentColor, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .03),
            const Label("Email"),
            Input(
              hintText: "Email",
              controller: _email,
              validator: (value) => validEmail(value!),
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
            SizedBox(height: MediaQuery.sizeOf(context).height * .05),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                name: "login",
                onPressed: _login,
                disabled: _disabled,
                loading: _loading,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * .2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: Style.body14.copyWith(color: AppColor.white),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    "Register",
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
