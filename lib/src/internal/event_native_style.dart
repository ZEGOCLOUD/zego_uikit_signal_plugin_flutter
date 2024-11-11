part of 'event_center.dart';

/// @nodoc
class ZegoSignalingPluginEventCenterPassthroughEvent {
  void Function(
    ZIM zim,
    ZIMConnectionState state,
    ZIMConnectionEvent event,
    Map extendedData,
  )? onConnectionStateChanged;

  void Function(
    ZIM zim,
    ZIMError errorInfo,
  )? onError;

  void Function(
    ZIM zim,
    int second,
  )? onTokenWillExpire;

  void Function(
    ZIM zim,
    List<ZIMConversationChangeInfo> conversationChangeInfoList,
  )? onConversationChanged;

  void Function(
    ZIM zim,
    int totalUnreadMessageCount,
  )? onConversationTotalUnreadMessageCountUpdated;

  void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromUserID,
  )? onReceivePeerMessage;
  void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromRoomID,
  )? onReceiveRoomMessage;
  void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromGroupID,
  )? onReceiveGroupMessage;

  void Function(
    ZIM zim,
    List<ZIMUserInfo> memberList,
    String roomID,
  )? onRoomMemberJoined;

  void Function(
    ZIM zim,
    List<ZIMUserInfo> memberList,
    String roomID,
  )? onRoomMemberLeft;

  void Function(
    ZIM zim,
    ZIMRoomState state,
    ZIMRoomEvent event,
    Map extendedData,
    String roomID,
  )? onRoomStateChanged;

  void Function(
    ZIM zim,
    ZIMRoomAttributesUpdateInfo updateInfo,
    String roomID,
  )? onRoomAttributesUpdated;

  void Function(
    ZIM zim,
    List<ZIMRoomAttributesUpdateInfo> updateInfo,
    String roomID,
  )? onRoomAttributesBatchUpdated;

  void Function(
    ZIM zim,
    List<ZIMRoomMemberAttributesUpdateInfo> infos,
    ZIMRoomOperatedInfo operatedInfo,
    String roomID,
  )? onRoomMemberAttributesUpdated;

  void Function(
    ZIM zim,
    ZIMGroupState state,
    ZIMGroupEvent event,
    ZIMGroupOperatedInfo operatedInfo,
    ZIMGroupFullInfo groupInfo,
  )? onGroupStateChanged;

  void Function(
    ZIM zim,
    String groupName,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupNameUpdated;

  void Function(
    ZIM zim,
    String groupAvatarUrl,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupAvatarUrlUpdated;

  void Function(
    ZIM zim,
    String groupNotice,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupNoticeUpdated;

  void Function(
    ZIM zim,
    List<ZIMGroupAttributesUpdateInfo> updateInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupAttributesUpdated;

  void Function(
    ZIM zim,
    ZIMGroupMemberState state,
    ZIMGroupMemberEvent event,
    List<ZIMGroupMemberInfo> userList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupMemberStateChanged;

  void Function(
    ZIM zim,
    List<ZIMGroupMemberInfo> userInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupMemberInfoUpdated;

  void Function(
    ZIM zim,
    ZIMCallInvitationReceivedInfo info,
    String callID,
  )? onCallInvitationReceived;
  void Function(
    ZIM zim,
    ZIMCallInvitationCancelledInfo info,
    String callID,
  )? onCallInvitationCancelled;
  void Function(
    ZIM zim,
    ZIMCallInvitationAcceptedInfo info,
    String callID,
  )? onCallInvitationAccepted;

  void Function(
    ZIM zim,
    ZIMCallInvitationRejectedInfo info,
    String callID,
  )? onCallInvitationRejected;

  void Function(
    ZIM zim,
    ZIMCallInvitationEndedInfo callInvitationEndedInfo,
    String callID,
  )? onCallInvitationEnded;

  void Function(
    ZIM zim,
    ZIMCallUserStateChangeInfo info,
    String invitationID,
  )? onCallUserStateChanged;

  void Function(
    ZIM zim,
    String callID,
  )? onCallInvitationTimeout;
  void Function(
    ZIM zim,
    List<String> invitees,
    String callID,
  )? onCallInviteesAnsweredTimeout;

  void Function(
    ZIM zim,
    List<ZIMMessageReceiptInfo> infos,
  )? onMessageReceiptChanged;

  void Function(
    ZIM zim,
    List<ZIMMessageReaction> infos,
  )? onMessageReactionsChanged;

  void Function(
    ZIM zim,
    List<ZIMMessageReceiptInfo> infos,
  )? onConversationMessageReceiptChanged;

  void Function(
    ZIM zim,
    List<ZIMRevokeMessage> messageList,
  )? onMessageRevokeReceived;

  void Function(
    ZPNsRegisterMessage registerMessage,
  )? onZPNsRegistered;
  void Function(
    ZPNsMessage message,
  )? onZPNsNotificationArrived;
  void Function(
    ZPNsMessage message,
  )? onZPNsNotificationClicked;
}
