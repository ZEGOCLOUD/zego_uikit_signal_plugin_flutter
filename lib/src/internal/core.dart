// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/internal/event_center.dart';
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';

/// @nodoc
class ZegoSignalingPluginCore {
  factory ZegoSignalingPluginCore() => _instance;

  ZegoSignalingPluginCore._() {
    ZegoSignalingLoggerService.logInfo(
      'ZegoSignalingPluginCore, created',
      tag: 'signaling',
      subTag: 'event center',
    );

    eventCenter.init();

    errorStreamCtrl ??= StreamController<ZegoSignalingError>.broadcast();
  }

  /// use is login or not
  bool get isLogin => currentUser != null;

  ZIMUserInfo? currentUser;
  final eventCenter = ZegoSignalingPluginEventCenter();

  StreamController<ZegoSignalingError>? errorStreamCtrl;

  static final _instance = ZegoSignalingPluginCore._();
}
