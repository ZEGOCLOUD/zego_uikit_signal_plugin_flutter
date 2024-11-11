// Package imports:
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_zim/zego_zim.dart';

extension ZIMCallInvitationReceivedInfoSignalingExtension
    on ZIMCallInvitationReceivedInfo {
  String toStringX() {
    return 'ZIMCallInvitationReceivedInfo{'
        'timeout:$timeout, '
        'inviter:$inviter, '
        'caller:$caller, '
        'extendedData:$extendedData, '
        'createTime:$createTime, '
        'mode:$mode, '
        'callUserList:${callUserList.map((e) => e.toStringX()).toList()}';
  }
}

extension ZIMCallUserInfoExtension on ZIMCallUserInfo {
  String toStringX() {
    return 'ZIMCallUserInfo{'
        'userID:$userID, '
        'state:$state, '
        'extendedData:$extendedData}';
  }
}

extension ZIMRoomAttributesUpdateInfoExtension on ZIMRoomAttributesUpdateInfo {
  String toStringX() {
    return 'ZIMRoomAttributesUpdateInfo{'
        'action:${action.name}, '
        'roomAttributes:$roomAttributes}';
  }
}

ZegoSignalingPluginInvitationUserState userStateConvertFunc(
    ZIMCallUserState state) {
  switch (state) {
    case ZIMCallUserState.unknown:
      return ZegoSignalingPluginInvitationUserState.unknown;
    case ZIMCallUserState.inviting:
      return ZegoSignalingPluginInvitationUserState.inviting;
    case ZIMCallUserState.accepted:
      return ZegoSignalingPluginInvitationUserState.accepted;
    case ZIMCallUserState.rejected:
      return ZegoSignalingPluginInvitationUserState.rejected;
    case ZIMCallUserState.cancelled:
      return ZegoSignalingPluginInvitationUserState.cancelled;
    case ZIMCallUserState.offline:
      return ZegoSignalingPluginInvitationUserState.offline;
    case ZIMCallUserState.received:
      return ZegoSignalingPluginInvitationUserState.received;
    case ZIMCallUserState.timeout:
      return ZegoSignalingPluginInvitationUserState.timeout;
    case ZIMCallUserState.quited:
      return ZegoSignalingPluginInvitationUserState.quited;
    case ZIMCallUserState.ended:
      return ZegoSignalingPluginInvitationUserState.ended;
    case ZIMCallUserState.notYetReceived:
      return ZegoSignalingPluginInvitationUserState.notYetReceived;
    case ZIMCallUserState.beCanceled:
      return ZegoSignalingPluginInvitationUserState.beCanceled;
  }
}

extension ZIMCallInvitationCancelledInfoExtension
    on ZIMCallInvitationCancelledInfo {
  String toStringX() {
    return 'ZIMCallInvitationCancelledInfo{'
        'inviter:$inviter, '
        'extendedData:$extendedData, '
        'mode:$mode, '
        '}';
  }
}
