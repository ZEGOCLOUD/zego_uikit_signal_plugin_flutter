// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/channel/platform_interface.dart';

/// @nodoc
/// An implementation of [ZegoSignalingPluginPlatform] that uses method channels.
class MethodChannelZegoSignalingPlugin extends ZegoSignalingPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zego_uikit_signaling_plugin');
}
