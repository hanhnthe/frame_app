import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'utils_method_channel.dart';

abstract class UtilsPlatform extends PlatformInterface {
  /// Constructs a UtilsPlatform.
  UtilsPlatform() : super(token: _token);

  static final Object _token = Object();

  static UtilsPlatform _instance = MethodChannelUtils();

  /// The default instance of [UtilsPlatform] to use.
  ///
  /// Defaults to [MethodChannelUtils].
  static UtilsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UtilsPlatform] when
  /// they register themselves.
  static set instance(UtilsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
