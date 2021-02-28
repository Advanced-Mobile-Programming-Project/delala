import 'package:delala/user/screens/signup_base.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static String logInRoute = "/";
  static String singUpRoute = "/sign_up";
  static String forgotPasswordRoute = "/forgot_password";
  static String authorizedRoute = "/authorized";
  static String moneyVault = "/vault";
  static String recharge = "/recharge";
  static String withdraw = "/withdraw";
  static String accounts = "/accounts";
  static String addAccount = "/add_account";
  static String profile = "/profile";
  static String updateBasicInfo = "/update_basic_info";
  static String updateEmail = "/update_email";
  static String updatePhoneNumber = "/update_phone_number";
  static String security = "/security";
  static String notification = "/notification";
  static String changePassword = "/change_password";
  static String sessionManagement = "/session_management";
}

class DelalaAppRoute {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == SignUp.routeName) {
      return MaterialPageRoute(builder: (context) => SignUp());
    }

    return MaterialPageRoute(builder: (context) => SignUp());
  }
}
