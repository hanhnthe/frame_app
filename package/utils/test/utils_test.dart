import 'package:flutter_test/flutter_test.dart';
import 'package:utils/utils.dart';
import 'package:utils/utils_platform_interface.dart';
import 'package:utils/utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockUtilsPlatform
    with MockPlatformInterfaceMixin
    implements UtilsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final UtilsPlatform initialPlatform = UtilsPlatform.instance;

  test('$MethodChannelUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelUtils>());
  });

  test('getPlatformVersion', () async {
    Utils utilsPlugin = Utils();
    MockUtilsPlatform fakePlatform = MockUtilsPlatform();
    UtilsPlatform.instance = fakePlatform;

    expect(await utilsPlugin.getPlatformVersion(), '42');
  });
}
