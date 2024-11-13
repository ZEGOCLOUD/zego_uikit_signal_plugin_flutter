part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginMessageAPIImpl
    implements ZegoSignalingPluginMessageAPI {
  /// send in-room text message
  @override
  Future<ZegoSignalingPluginInRoomTextMessageResult> sendInRoomTextMessage({
    required String roomID,
    required String message,
  }) {
    return ZIM
        .getInstance()!
        .sendMessage(
          ZIMTextMessage(message: message),
          roomID,
          ZIMConversationType.room,
          ZIMMessageSendConfig(),
        )
        .then((ZIMMessageSentResult zimResult) {
      return const ZegoSignalingPluginInRoomTextMessageResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'send in-room text message, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'message',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.inRoomTextMessageSendError,
              message:
                  'room id:$roomID, message:$message, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInRoomTextMessage',
            ),
          );

      return ZegoSignalingPluginInRoomTextMessageResult(
        error: error,
      );
    });
  }

  /// send in-room command message
  @override
  Future<ZegoSignalingPluginInRoomCommandMessageResult>
      sendInRoomCommandMessage({
    required String roomID,
    required Uint8List message,
  }) {
    return ZIM
        .getInstance()!
        .sendMessage(
          ZIMCommandMessage(message: message),
          roomID,
          ZIMConversationType.room,
          ZIMMessageSendConfig(),
        )
        .then((ZIMMessageSentResult zimResult) {
      return const ZegoSignalingPluginInRoomCommandMessageResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'send in-room command message, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'message',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.inRoomCommandMessageSendError,
              message:
                  'room id:$roomID, message:$message, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInRoomCommandMessage',
            ),
          );

      return ZegoSignalingPluginInRoomCommandMessageResult(
        error: error,
      );
    });
  }
}

/// @nodoc
class ZegoSignalingPluginMessageEventImpl
    implements ZegoSignalingPluginMessageEvent {
  /// in-room text message received event
  @override
  Stream<ZegoSignalingPluginInRoomTextMessageReceivedEvent>
      getInRoomTextMessageReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .inRoomTextMessageReceived
        .stream;
  }

  /// in-room command message received event
  @override
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      getInRoomCommandMessageReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .inRoomCommandMessageReceived
        .stream;
  }
}
