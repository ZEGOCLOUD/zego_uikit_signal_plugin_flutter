// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_uikit_signaling_plugin/src/log/logger_service.dart';

void testZIMTypes() {
  ZegoSignalingLoggerService.logInfo(
    'test zim types begin',
    tag: 'signaling',
    subTag: 'test',
  );

  if (ZegoSignalingPluginConnectionState.values.length !=
      ZIMConnectionState.values.length) {
    ZegoSignalingLoggerService.logError(
      'ZegoSignalingPluginConnectionState != ZIMConnectionState, '
      'ZegoSignalingPluginConnectionState:${ZegoSignalingPluginConnectionState.values}, '
      'ZIMConnectionState:${ZIMConnectionState.values}, ',
      tag: 'signaling',
      subTag: 'test',
    );
  }

  if (ZegoSignalingPluginConnectionAction.values.length !=
      ZIMConnectionEvent.values.length) {
    ZegoSignalingLoggerService.logError(
      'ZegoSignalingPluginConnectionAction != ZIMConnectionEvent, '
      'ZegoSignalingPluginConnectionAction:${ZegoSignalingPluginConnectionAction.values}, '
      'ZIMConnectionEvent:${ZIMConnectionEvent.values}, ',
      tag: 'signaling',
      subTag: 'test',
    );
  }

  if (ZegoSignalingPluginRoomAction.values.length !=
      ZIMRoomEvent.values.length) {
    ZegoSignalingLoggerService.logError(
      'ZegoSignalingPluginRoomAction != ZIMRoomEvent, '
      'ZegoSignalingPluginRoomAction:${ZegoSignalingPluginRoomAction.values}, '
      'ZIMRoomEvent:${ZIMRoomEvent.values}, ',
      tag: 'signaling',
      subTag: 'test',
    );
  }

  if (ZegoSignalingPluginRoomState.values.length !=
      ZIMRoomState.values.length) {
    ZegoSignalingLoggerService.logError(
      'ZegoSignalingPluginRoomState != ZIMRoomState, '
      'ZegoSignalingPluginRoomState:${ZegoSignalingPluginRoomState.values}, '
      'ZIMRoomState:${ZIMRoomState.values}, ',
      tag: 'signaling',
      subTag: 'test',
    );
  }

  if (ZegoSignalingPluginCallUserState.values.length !=
      ZIMCallUserState.values.length) {
    ZegoSignalingLoggerService.logError(
      'ZegoSignalingPluginCallUserState != ZIMCallUserState, '
      'ZegoSignalingPluginCallUserState:${ZegoSignalingPluginCallUserState.values}, '
      'ZIMCallUserState:${ZIMCallUserState.values}, ',
      tag: 'signaling',
      subTag: 'test',
    );
  }

  ZegoSignalingLoggerService.logInfo(
    'test zim types done',
    tag: 'signaling',
    subTag: 'test',
  );
}
