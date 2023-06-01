import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'utils_platform_interface.dart';

/// An implementation of [UtilsPlatform] that uses method channels.
class MethodChannelUtils extends UtilsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('utils');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
