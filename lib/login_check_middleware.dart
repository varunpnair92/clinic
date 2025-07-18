import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

class RoleMiddleware extends GetMiddleware {
  final List<String> allowedRoles;

  RoleMiddleware({required this.allowedRoles});

  @override
  RouteSettings? redirect(String? route) {
    SharedPreferences.getInstance().then((prefs) {
      final role = prefs.getString('role') ?? '';

      if (!allowedRoles.contains(role)) {
        // Use Get.offAll directly since redirect can't handle Future returns.
        Get.offAllNamed('/login');
      }
    });

    // Return null immediately to avoid blocking navigation.
    return null;
  }
}
