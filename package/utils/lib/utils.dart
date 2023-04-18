import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  ///Bkav HoangLD : hiệu ứng chuyển giữa các page khác nhau
  static Route pageRouteBuilder(Widget widget, bool transitions) {
    if (transitions) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    } else {
      return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget);
    }
  }

  ///Bkav TungDV check check man hinh ngang doc de fix loi tai tho tren ios
  static Widget bkavCheckOrientation(BuildContext context, Widget child) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Container(child: child)
        : SafeArea(
            top: false,
            child: child,
          );
  }

  /// HanhNTHe: Lay thong tin dinh danh cua user trong sharePref
  /// co the la userId, userName,... tuy thuoc vao project
  static Future<String> getUserIdInSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("user_identifier") ?? "-1";
    return userId;
  }

  /// HanhNTHe: Lưu thong tin dinh danh cua user trong sharePref
  /// co the la userId, userName,... tuy thuoc vao project
  static Future<void> saveUserIdInSharePref(
      {required String userIdentifier}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user_identifier", userIdentifier);
  }
}
