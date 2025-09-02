import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_van/widgets/app_button.dart';
import 'package:kids_van/widgets/app_input.dart';
import '../../routes/app_routes.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppInput(hint: "Email", controller: emailController),
            const SizedBox(height: 12),
            AppInput(hint: "Password", controller: passwordController, obscureText: true),
            const SizedBox(height: 20),
            AppButton(
              text: "Login",
              onPressed: () {
                // Example role navigation
                Get.offAllNamed(AppRoutes.parentHome);
              },
            )
          ],
        ),
      ),
    );
  }
}
