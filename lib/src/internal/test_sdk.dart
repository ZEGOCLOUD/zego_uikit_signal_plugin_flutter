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

  assert(ZegoSignalingPluginConnectionState.values.length ==
      ZIMConnectionState.values.length);
  assert(ZegoSignalingPluginConnectionAction.values.length ==
      ZIMConnectionEvent.values.length);
  assert(ZegoSignalingPluginRoomAction.values.length ==
      ZIMRoomEvent.values.length);
  assert(
      ZegoSignalingPluginRoomState.values.length == ZIMRoomState.values.length);
  assert(ZegoSignalingPluginCallUserState.values.length ==
      ZIMCallUserState.values.length);

  ZegoSignalingLoggerService.logInfo(
    'test zim types done',
    tag: 'signaling',
    subTag: 'test',
  );
}
