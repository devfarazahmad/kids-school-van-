import 'package:get/get.dart';
import 'package:kids_van/views/common/admin_home_view.dart';
import 'package:kids_van/views/common/driver_home_view.dart';
import 'package:kids_van/views/common/parent_home_view.dart';
import 'package:kids_van/views/common/splash_view_model.dart';
import '../views/common/role_select_view.dart';
import '../views/common/login_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.roleSelect, page: () => const RoleSelectView()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.parentHome, page: () => const ParentHomeView()),
    GetPage(name: AppRoutes.driverHome, page: () => const DriverHomeView()),
    GetPage(name: AppRoutes.adminHome, page: () => const AdminHomeView()),
  ];
}
