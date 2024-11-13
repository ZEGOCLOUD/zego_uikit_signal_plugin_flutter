// Package imports:
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Project imports:
import 'method_channel.dart';

/// @nodoc
abstract class ZegoSignalingPluginPlatform extends PlatformInterface {
  /// Constructs a ZegoSignalingPluginPlatform.
  ZegoSignalingPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZegoSignalingPluginPlatform _instance =
      MethodChannelZegoSignalingPlugin();

  /// The default instance of [ZegoSignalingPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUntitled].
  static ZegoSignalingPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZegoSignalingPluginPlatform] when
  /// they register themselves.
  static set instance(ZegoSignalingPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
