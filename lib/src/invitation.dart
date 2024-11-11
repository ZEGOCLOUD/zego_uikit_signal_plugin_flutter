part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginInvitationAPIImpl
    implements ZegoSignalingPluginInvitationAPI {
  /// send invitation
  @override
  Future<ZegoSignalingPluginSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    bool isAdvancedMode = false,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'send invitation, invitees:$invitees, '
      'timeout:$timeout, '
      'extendedData:$extendedData, '
      'push config:${pushConfig.toString()}, '
      'isAdvancedMode:$isAdvancedMode, ',
      tag: 'signaling',
      subTag: 'invitation',
    );

    final config = ZIMCallInviteConfig()
      ..extendedData = extendedData
      ..timeout = timeout
      ..mode = isAdvancedMode
          ? ZIMCallInvitationMode.advanced
          : ZIMCallInvitationMode.general
      ..pushConfig = _toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'send invitation, done, invitation id:${zimResult.callID}, '
        'error user list:${zimResult.info.errorUserList.map((e) => '${e.userID}, reason:${e.reason}')}, '
        'error invitees:${zimResult.info.errorInvitees.map((e) => '${e.userID}, ')}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: zimResult.callID,
        errorInvitees: {
          for (var element in zimResult.info.errorUserList)
            element.userID: element.reason
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'send invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationSendError,
              message:
                  'invitees:$invitees, timeout:$timeout, extended data:$extendedData, notification config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInvitation',
            ),
          );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: '',
        errorInvitees: {},
        error: error,
      );
    });
  }

  /// add invitation
  @override
  Future<ZegoSignalingPluginSendInvitationResult> addInvitation({
    required List<String> invitees,
    required String invitationID,
    ZegoSignalingPluginPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'add invitation, invitees:$invitees, '
      'invitationID:$invitationID, '
      'push config:${pushConfig.toString()}',
      tag: 'signaling',
      subTag: 'invitation',
    );

    final config = ZIMCallingInviteConfig()
      ..pushConfig = _toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callingInvite(invitees, invitationID, config)
        .then((ZIMCallingInvitationSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'add invitation, done, invitation id:${zimResult.callID}, '
        'error user list:${zimResult.info.errorUserList.map((e) => '${e.userID}, reason:${e.reason}')}, ',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: zimResult.callID,
        errorInvitees: {
          for (var element in zimResult.info.errorUserList)
            element.userID: element.reason
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'add invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationAddError,
              message:
                  'invitees:$invitees, invitationID:$invitationID, notification config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'addInvitation',
            ),
          );

      return ZegoSignalingPluginSendInvitationResult(
        invitationID: '',
        errorInvitees: {},
        error: error,
      );
    });
  }

  /// join invitation
  @override
  Future<ZegoSignalingPluginJoinInvitationResult> joinInvitation({
    required String invitationID,
    String extendedData = '',
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'join invitation, '
      'invitationID:$invitationID, '
      'extendedData:$extendedData, ',
      tag: 'signaling',
      subTag: 'invitation',
    );

    final config = ZIMCallJoinConfig()..extendedData = extendedData;

    return ZIM
        .getInstance()!
        .callJoin(invitationID, config)
        .then((ZIMCallJoinSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'join invitation, done, invitation id:${zimResult.callID}, ',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginJoinInvitationResult(
        invitationID: zimResult.callID,
        callUserList: zimResult.info.callUserList
            .map((userInfo) => ZegoSignalingPluginInvitationUserInfo(
                  userID: userInfo.userID,
                  state: userStateConvertFunc(userInfo.state),
                  extendedData: userInfo.extendedData,
                ))
            .toList(),
        extendedData: zimResult.info.extendedData,
        createTime: zimResult.info.createTime,
        joinTime: zimResult.info.joinTime,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'join invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationJoinError,
              message:
                  'exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'joinInvitation',
            ),
          );

      return ZegoSignalingPluginJoinInvitationResult(
        invitationID: '',
        error: error,
      );
    });
  }

  /// cancel invitation
  @override
  Future<ZegoSignalingPluginCancelInvitationResult> cancelInvitation({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
    ZegoSignalingPluginIncomingInvitationCancelPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'cancel invitation, invitation id:$invitationID, invitees:$invitees, '
      'extendedData:$extendedData, pushConfig:$pushConfig',
      tag: 'signaling',
      subTag: 'invitation',
    );

    var config = ZIMCallCancelConfig();
    config.extendedData = extendedData;
    if (null != pushConfig) {
      var zimPushConfig = ZIMPushConfig();
      zimPushConfig.title = pushConfig.title;
      zimPushConfig.content = pushConfig.content;
      zimPushConfig.payload = pushConfig.payload;
      zimPushConfig.resourcesID = pushConfig.resourcesID;

      config.pushConfig = zimPushConfig;
    }
    return ZIM
        .getInstance()!
        .callCancel(
          invitees,
          invitationID,
          config,
        )
        .then((ZIMCallCancelSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'cancel invitation, done, invitation id:${zimResult.callID}, '
        'error invitees:${zimResult.errorInvitees}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'cancel invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationCancelError,
              message:
                  'invitation id:$invitationID, invitees:$invitees, extended data:$extendedData, push config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'cancelInvitation',
            ),
          );

      return ZegoSignalingPluginCancelInvitationResult(
        errorInvitees: invitees,
        error: error,
      );
    });
  }

  /// refuse invitation
  @override
  Future<ZegoSignalingPluginResponseInvitationResult> refuseInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoSignalingLoggerService.logInfo(
      'refuse invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'invitation',
    );

    return ZIM
        .getInstance()!
        .callReject(
          invitationID,
          ZIMCallRejectConfig()..extendedData = extendedData,
        )
        .then((ZIMCallRejectionSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'refuse invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'refuse invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationRefuseError,
              message:
                  'invitation id:$invitationID, extended data:$extendedData, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'refuseInvitation',
            ),
          );

      return ZegoSignalingPluginResponseInvitationResult(error: error);
    });
  }

  /// accept invitation
  @override
  Future<ZegoSignalingPluginResponseInvitationResult> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoSignalingLoggerService.logInfo(
      'accept invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'signaling',
      subTag: 'invitation',
    );

    return ZIM
        .getInstance()!
        .callAccept(
          invitationID,
          ZIMCallAcceptConfig()..extendedData = extendedData,
        )
        .then((ZIMCallAcceptanceSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'accept invitation, done, invitation id:${zimResult.callID}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return const ZegoSignalingPluginResponseInvitationResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'accept invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationAcceptError,
              message:
                  'invitation id:$invitationID, extended data:$extendedData, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'acceptInvitation',
            ),
          );

      return ZegoSignalingPluginResponseInvitationResult(error: error);
    });
  }

  ZIMPushConfig? _toZIMPushConfig(
    ZegoSignalingPluginPushConfig? pushConfig,
  ) {
    ZIMPushConfig? zimPushConfig = (pushConfig != null)
        ? (ZIMPushConfig()
          ..title = pushConfig.title
          ..content = pushConfig.message
          ..resourcesID = pushConfig.resourceID
          ..payload = pushConfig.payload)
        : null;
    if (null != pushConfig?.voipConfig) {
      zimPushConfig?.voIPConfig = ZIMVoIPConfig();
      zimPushConfig?.voIPConfig?.iOSVoIPHasVideo =
          pushConfig?.voipConfig?.iOSVoIPHasVideo ?? false;
    }

    return zimPushConfig;
  }

  /// end invitation
  @override
  Future<ZegoSignalingPluginEndInvitationResult> endInvitation({
    required String invitationID,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'end invitation, invitationID:$invitationID, '
      'extendedData:$extendedData, '
      'push config:${pushConfig.toString()}',
      tag: 'signaling',
      subTag: 'invitation',
    );
    final config = ZIMCallEndConfig()
      ..extendedData = extendedData
      ..pushConfig = _toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callEnd(invitationID, config)
        .then((ZIMCallEndSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'end invitation, done, '
        'invitation id:${zimResult.callID}, '
        'createTime:${zimResult.info.createTime}, '
        'acceptTime:${zimResult.info.acceptTime}, '
        'endTime:${zimResult.info.endTime}, ',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginEndInvitationResult(
        invitationID: zimResult.callID,
        createTime: zimResult.info.createTime,
        acceptTime: zimResult.info.acceptTime,
        endTime: zimResult.info.endTime,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'add invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationEndError,
              message:
                  'invitationID:$invitationID, notification config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInvitation',
            ),
          );

      return ZegoSignalingPluginEndInvitationResult(error: error);
    });
  }

  /// quit invitation
  @override
  Future<ZegoSignalingPluginQuitInvitationResult> quitInvitation({
    required String invitationID,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'quit invitation, invitationID:$invitationID, '
      'extendedData:$extendedData, '
      'push config:${pushConfig.toString()}',
      tag: 'signaling',
      subTag: 'invitation',
    );
    final config = ZIMCallQuitConfig()
      ..extendedData = extendedData
      ..pushConfig = _toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callQuit(invitationID, config)
        .then((ZIMCallQuitSentResult zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'quit invitation, done, '
        'invitation id:${zimResult.callID}, '
        'createTime:${zimResult.info.createTime}, '
        'acceptTime:${zimResult.info.acceptTime}, '
        'quitTime:${zimResult.info.quitTime}, ',
        tag: 'signaling',
        subTag: 'invitation',
      );

      return ZegoSignalingPluginQuitInvitationResult(
        invitationID: zimResult.callID,
        createTime: zimResult.info.createTime,
        acceptTime: zimResult.info.acceptTime,
        quitTime: zimResult.info.quitTime,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'quit invitation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'invitation',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.invitationQuitError,
              message:
                  'invitationID:$invitationID, notification config:$pushConfig, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'sendInvitation',
            ),
          );

      return ZegoSignalingPluginQuitInvitationResult(error: error);
    });
  }
}

/// @nodoc
class ZegoSignalingPluginInvitationEventImpl
    implements ZegoSignalingPluginInvitationEvent {
  /// user state changed event
  @override
  Stream<ZegoSignalingPluginInvitationUserStateChangedEvent>
      getInvitationUserStateChangedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.userStateChangedEvent.stream;
  }

  /// incoming invitation received event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationReceivedEvent>
      getIncomingInvitationReceivedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationReceivedEvent
        .stream;
  }

  /// incoming invitation cancelled event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationCancelledEvent>
      getIncomingInvitationCancelledEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationCancelledEvent
        .stream;
  }

  /// outgoing invitation accepted event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationAcceptedEvent>
      getOutgoingInvitationAcceptedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationAcceptedEvent
        .stream;
  }

  /// outgoing invitation rejected event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationRejectedEvent>
      getOutgoingInvitationRejectedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationRejectedEvent
        .stream;
  }

  /// outgoing invitation ended event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationEndedEvent>
      getOutgoingInvitationEndedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationEndedEvent
        .stream;
  }

  /// incoming invitation timeout event
  @override
  Stream<ZegoSignalingPluginIncomingInvitationTimeoutEvent>
      getIncomingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .incomingInvitationTimeoutEvent
        .stream;
  }

  /// outgoing invitation timeout event
  @override
  Stream<ZegoSignalingPluginOutgoingInvitationTimeoutEvent>
      getOutgoingInvitationTimeoutEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .outgoingInvitationTimeoutEvent
        .stream;
  }
}
