import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_van/widgets/app_button.dart';
import '../../routes/app_routes.dart';

class RoleSelectView extends StatelessWidget {
  const RoleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppButton(text: "Parent", onPressed: () => Get.toNamed(AppRoutes.login)),
            const SizedBox(height: 12),
            AppButton(text: "Driver", onPressed: () => Get.toNamed(AppRoutes.login)),
            const SizedBox(height: 12),
            AppButton(text: "Administrator", onPressed: () => Get.toNamed(AppRoutes.login)),
          ],
        ),
      ),
    );
  }
}
