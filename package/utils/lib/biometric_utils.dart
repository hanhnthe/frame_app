import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils/preference_utils.dart';
import 'package:utils/shared_preferences_key.dart';
import 'package:utils/utils.dart';

/// Bkav HoangLD cac trang thai khi lay mat khau dang nhap tai khoan bang biometric
enum GetPasswordBiometricStatus { successful, failure, moreThan3, none }

/// Logic lien quan den setup van tay / face id
class BiometricUtils {
  static Future<bool> isBiometrics() async {
    bool isCanCheckBiometric = await LocalAuthentication().canCheckBiometrics;
    return isCanCheckBiometric;
  }

  static Future<bool> statusFaceID({String? key}) async {
    final prefs = await SharedPreferences.getInstance();
    String userName = await Utils.getUserIdInSharePref();
    String faceIDSettingSharePref =
        prefs.getString((key ?? userName).toLowerCase()) ??
            jsonEncode(SettingSharePref.toJson(false, false));
    return SettingSharePref.fromJson(jsonDecode(faceIDSettingSharePref))
        .isFaceId;
  }

  static Future<bool> statusFingerprint({String? key}) async {
    final prefs = await SharedPreferences.getInstance();
    String userName = await Utils.getUserIdInSharePref();
    String fingerprintSettingSharePref =
        prefs.getString((key ?? userName).toLowerCase()) ??
            jsonEncode(SettingSharePref.toJson(false, false));
    return SettingSharePref.fromJson(jsonDecode(fingerprintSettingSharePref))
        .isFingerPrint;
  }

  static Future<BiometricType> isBiometricSupport() async {
    bool statusFingerprint = await BiometricUtils.statusFingerprint();
    bool statusFaceID = await BiometricUtils.statusFaceID();

    List<BiometricType> availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    if (statusFaceID || statusFingerprint) {
      if (Platform.isAndroid) {
        if (availableBiometrics.contains(BiometricType.strong)) {
          return BiometricType.fingerprint;
        }
      } else if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          return BiometricType.face;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          return BiometricType.fingerprint;
        }
      }
    }
    return BiometricType.iris;
  }

  static Future<Object> _checkAuthenticateBiometric(String authenticate) async {
    final canCheckBiometric = await isBiometrics();
    if (!canCheckBiometric) {
      return GetPasswordBiometricStatus.none;
    } else {
      try {
        bool statusAuthenticate = await LocalAuthentication().authenticate(
            localizedReason:
                'Vui lòng quét vân tay để đăng nhập ứng dụng (lưu ý: Quý khách có thể sử dụng Vân tay đã đăng ký thành công trên thiết bị)',
            authMessages: [] /* <AuthMessages>[
              AndroidAuthMessages(
                  signInTitle: S
                      .of(NavigationService.navigatorKey.currentContext!)
                      .fingerprint_authentication,
                  biometricHint: "",
                  cancelButton: S
                      .of(NavigationService.navigatorKey.currentContext!)
                      .cancel),
            ]*/
            ,
            options: const AuthenticationOptions(
                useErrorDialogs: false, biometricOnly: true));
        if (statusAuthenticate) {
          return GetPasswordBiometricStatus.successful;
        } else {
          return GetPasswordBiometricStatus.failure;
        }
      } on PlatformException {
        return GetPasswordBiometricStatus.moreThan3;
      }
    }
  }

  static Future<BiometricType> isBiometricSupportSetting() async {
    List<BiometricType> availableBiometrics =
        await LocalAuthentication().getAvailableBiometrics();
    if (Platform.isAndroid) {
      if (availableBiometrics.contains(BiometricType.strong)) {
        return BiometricType.fingerprint;
      }
    } else if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricType.fingerprint;
      }
    }
    return BiometricType.iris;
  }

  //HoangLD tạo 1 channel để call native ios
  static const _channelBkav = MethodChannel('com.bkav.utils/bkav_channel');

  //HoangLD check xem faceid đã được cài trên thiết bị không
  static Future<bool> checkBiometricsFaceIdIos() async {
    bool faceId = false;
    if (Platform.isIOS) {
      String checkIos = await _channelBkav.invokeMethod('getBiometricType');
      if (checkIos == "faceID") {
        faceId = true;
      } else {
        faceId = false;
      }
    }
    return faceId;
  }
  // HoangLD lưu Biometric của IOS
  static void checkBiometricsSaveChangeIos() async{
    if (Platform.isIOS) {
      //final prefs = await SharedPreferences.getInstance();
      String statusIOS = await _channelBkav.invokeMethod('getStatusBiometric');
      await (await SharedPrefs.instance()).setString(SharedPreferencesKey.saveStatusChangeIOS, statusIOS);
    }
  }
  //Bkav HoangLD call native lấy trạng thái vân tay thay đổi android
  static Future<bool> checkBiometricsSaveChangeAndroid() async{
    var params =  <String, String>{"accessToken":"","typeId":""};
    bool statusAndroid = await _channelBkav.invokeMethod('getStatusBiometricAndroid', params);
    return statusAndroid;
  }
  //Bkav HoangLD call native đăng nhập xong reset trạng thái vân tay trên android
  static void resetBiometricAndroid() async{
    var params =  <String, String>{"accessToken":"","typeId":""};
    await _channelBkav.invokeMethod('resetBiometricAndroid',params);
  }
  // HoangLD check state Biometric có thay đổi không
  static Future<bool> checkBiometricsChangeIos() async{
    bool changeIos = true;
    if (Platform.isIOS) {
      //final prefs = await SharedPreferences.getInstance();
      String checkIos = await _channelBkav.invokeMethod('getStatusBiometric');
      String statusIOS = (await SharedPrefs.instance()).getString(SharedPreferencesKey.saveStatusChangeIOS) ?? "";
      if(checkIos == statusIOS){
        changeIos = false;
      }else{
        changeIos = true;
      }
    }else if(Platform.isAndroid){
      final LocalAuthentication auth = LocalAuthentication();
      final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
      if(availableBiometrics.isNotEmpty){
        changeIos = await checkBiometricsSaveChangeAndroid();
      }else{
        changeIos = false;
      }
    }
    return changeIos;
  }
  /// Lưu mật khẩu vào trong vùng bộ nhớ an toàn (SecureStorage) để dùng khi đăng
  /// nhập bằng vân tay/ face id nếu cần
  Future<void> savePassLogin(String key, String value) async {
    const storage = FlutterSecureStorage();
    key = key.toLowerCase();
    await storage.write(
        key: key.toLowerCase(),
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: IOSOptions(
            accountName: key, accessibility: KeychainAccessibility.unlocked));
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  /// Lấy mật khẩu vào trong vùng bộ nhớ an toàn (SecureStorage) để dùng khi đăng
  /// nhập bằng vân tay/ face id nếu cần
  Future<String?> getPassLogin(
      String key, BiometricType biometricType, BuildContext context) async {
    // neu nguoi dung khong duoc phep dang nhap bang local auth
    bool statusFingerprint =
        await BiometricUtils.statusFingerprint(key: key.toLowerCase());
    bool statusFaceID =
        await BiometricUtils.statusFaceID(key: key.toLowerCase());
    debugPrint(" statusFingerprint = ${statusFingerprint.toString()}");
    if (biometricType == BiometricType.face && !statusFaceID) {
      return "";
    }
    if (biometricType == BiometricType.fingerprint && !statusFingerprint) {
      return "";
    }
    const storage = FlutterSecureStorage();
    key = key.toLowerCase();
    String authenticate = "";
    if (biometricType == BiometricType.face) {
      authenticate = "FaceID";
    } else if (biometricType == BiometricType.fingerprint) {
      authenticate = "FingerPrint";
    }
    if (authenticate.isEmpty) {
      return authenticate;
    }
    //HoangLD kiem tra lai cac trang thai
    Object statusAuthenticated =
        await _checkAuthenticateBiometric(authenticate);
    if (statusAuthenticated == GetPasswordBiometricStatus.successful) {
      return await storage.read(
          key: key.toLowerCase(),
          aOptions: _getAndroidOptions(),
          iOptions: IOSOptions(
              accountName: key, accessibility: KeychainAccessibility.unlocked));
    } else if (statusAuthenticated == GetPasswordBiometricStatus.failure) {
      return null;
    } else if (statusAuthenticated == GetPasswordBiometricStatus.moreThan3) {
      return "${GetPasswordBiometricStatus.moreThan3}";
    }
    return "";
  }
}

class SettingSharePref {
  bool isFingerPrint;
  bool isFaceId;

  static String statusFingerprintKey = "statusFingerprint";
  static String statusFaceIDKey = "statusFaceID";

  SettingSharePref({required this.isFingerPrint, required this.isFaceId});

  factory SettingSharePref.fromJson(Map<String, dynamic> json) {
    return SettingSharePref(
        isFingerPrint: json[statusFingerprintKey],
        isFaceId: json[statusFaceIDKey]);
  }

  static Map<String, dynamic> toJson(bool isFingerPrint, bool isFaceId) {
    return {statusFingerprintKey: isFingerPrint, statusFaceIDKey: isFaceId};
  }
}
