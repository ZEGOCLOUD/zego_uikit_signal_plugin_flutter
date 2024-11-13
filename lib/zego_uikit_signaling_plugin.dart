// Dart imports:
import 'dart:async';
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/internal/core.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/event_center.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/test_sdk.dart';
import 'package:zego_uikit_signaling_plugin/src/internal/zim_extension.dart';
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';

export 'package:zego_zim/zego_zim.dart' hide ZIMEventHandler;

part 'src/invitation.dart';

part 'src/message.dart';

part 'src/notification.dart';

part 'src/room.dart';

part 'src/user.dart';

part 'src/background_message.dart';

part 'src/callkit.dart';

/// @nodoc
class ZegoUIKitSignalingPlugin
    with
        ZegoSignalingPluginRoomAPIImpl,
        ZegoSignalingPluginRoomEventImpl,
        ZegoSignalingPluginInvitationAPIImpl,
        ZegoSignalingPluginInvitationEventImpl,
        ZegoSignalingPluginUserAPIImpl,
        ZegoSignalingPluginUserEventImpl,
        ZegoSignalingPluginNotificationAPIImpl,
        ZegoSignalingPluginNotificationEventImpl,
        ZegoSignalingPluginMessageAPIImpl,
        ZegoSignalingPluginMessageEventImpl,
        ZegoSignalingPluginBackgroundMessageAPIImpl,
        ZegoSignalingPluginBackgroundMessageEventImpl,
        ZegoSignalingPluginCallKitAPIImpl,
        ZegoSignalingPluginCallKitEventImpl,
        IZegoUIKitPlugin
    implements ZegoSignalingPluginInterface {
  ZegoSignalingPluginEventCenter get eventCenter =>
      ZegoSignalingPluginCore().eventCenter;

  factory ZegoUIKitSignalingPlugin() => instance;

  ZegoUIKitSignalingPlugin._();

  static final ZegoUIKitSignalingPlugin instance = ZegoUIKitSignalingPlugin._();

  /// getPluginType
  @override
  ZegoUIKitPluginType getPluginType() => ZegoUIKitPluginType.signaling;

  /// getVersion
  @override
  Future<String> getVersion() async {
    final zimVersion = await ZIM.getVersion();
    const signalingVersion = 'zego_uikit_signaling_plugin: 2.8.6;';
    if (!kIsWeb && (io.Platform.isAndroid || io.Platform.isIOS)) {
      final zpnsVersion = await ZPNs.getVersion();
      return '$signalingVersion zim:$zimVersion; zpns:$zpnsVersion;';
    } else {
      return '$signalingVersion zim:$zimVersion;';
    }
  }

  @override
  Future<void> setAdvancedConfig(String key, String value) async {
    ZegoSignalingLoggerService.logInfo(
      'key:$key, value:$value',
      tag: 'signaling',
      subTag: 'set advanced config',
    );

    await ZIM.setAdvancedConfig(key, value);

    ZegoSignalingLoggerService.logInfo(
      'key:$key, value:$value',
      tag: 'signaling',
      subTag: 'set advanced config done',
    );
  }

  /// init
  @override
  Future<void> init({required int appID, String appSign = ''}) async {
    testZIMTypes();

    await ZegoSignalingLoggerService().initLog();

    ZegoSignalingLoggerService.logInfo(
      'create ZIM',
      tag: 'signaling',
      subTag: 'init',
    );

    if (null != ZIM.getInstance()) {
      ZegoSignalingLoggerService.logInfo(
        'ZIM is create before',
        tag: 'signaling',
        subTag: 'init',
      );

      return;
    }

    ZegoSignalingLoggerService.logInfo(
      'ZIM create, '
      'appID:$appID, '
      'has appSign:${appSign.isNotEmpty}',
      tag: 'signaling',
      subTag: 'init',
    );

    ZIM.create(
      ZIMAppConfig()
        ..appID = appID
        ..appSign = appSign,
    );
  }

  /// uninit
  @override
  Future<void> uninit() async {
    ZegoSignalingLoggerService.logInfo(
      'destroy ZIM',
      tag: 'signaling',
      subTag: 'uninit',
    );

    ZIM.getInstance()?.destroy();
  }

  /// getErrorEventStream
  @override
  Stream<ZegoSignalingPluginErrorEvent> getErrorEventStream() {
    return ZegoSignalingPluginCore().eventCenter.errorEvent.stream;
  }

  /// getErrorStream
  @override
  Stream<ZegoSignalingError> getErrorStream() {
    return ZegoSignalingPluginCore().errorStreamCtrl?.stream ??
        const Stream.empty();
  }
}
