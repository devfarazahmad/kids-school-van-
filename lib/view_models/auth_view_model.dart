import 'package:get/get.dart';


enum UserRole { parent, driver, admin }


class AuthViewModel extends GetxController {
final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);
final RxBool isLoading = false.obs;


void chooseRole(UserRole role) {
selectedRole.value = role;
}


Future<void> login(String phone, String pin) async {
isLoading.value = true;
await Future.delayed(const Duration(milliseconds: 700)); // mock
isLoading.value = false;
switch (selectedRole.value) {
case UserRole.parent:
Get.offAllNamed('/parent-home');
break;
case UserRole.driver:
Get.offAllNamed('/driver-home');
break;
case UserRole.admin:
Get.offAllNamed('/admin-home');
break;
default:
break;
}
}
}