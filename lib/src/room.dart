part of '../zego_uikit_signaling_plugin.dart';

/// @nodoc
class ZegoSignalingPluginRoomAPIImpl implements ZegoSignalingPluginRoomAPI {
  /// join room(create and enter)
  @override
  Future<ZegoSignalingPluginJoinRoomResult> joinRoom({
    required String roomID,
    required String roomName,
    Map<String, String> roomAttributes = const {},
    int roomDestroyDelayTime = 0,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'join room, room id:$roomID, room name:$roomName',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .enterRoom(
          ZIMRoomInfo()
            ..roomID = roomID
            ..roomName = roomName,
          ZIMRoomAdvancedConfig()
            ..roomAttributes = roomAttributes
            ..roomDestroyDelayTime = roomDestroyDelayTime,
        )
        .then((zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'join room finish',
        tag: 'signaling',
        subTag: 'room',
      );

      assert(zimResult.roomInfo.baseInfo.roomID.isNotEmpty,
          'zimResult.roomInfo.baseInfo.roomID.isNotEmpty');

      return const ZegoSignalingPluginJoinRoomResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'join room, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      if (error is PlatformException &&
          int.parse(error.code) ==
              ZIMErrorCode.roomModuleTheRoomAlreadyExists) {
        /// room is exist, just call join room
        return _joinRoom(roomID: roomID);
      }

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomLoginError,
              message:
                  'room id:$roomID, room name:$roomName, room attributes:$roomAttributes, room destroy delay time:$roomDestroyDelayTime, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'joinRoom',
            ),
          );

      return ZegoSignalingPluginJoinRoomResult(
        error: error,
      );
    });
  }

  Future<ZegoSignalingPluginJoinRoomResult> _joinRoom({
    required String roomID,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'zim join room, room id:$roomID',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM.getInstance()!.joinRoom(roomID).then((zimResult) {
      ZegoSignalingLoggerService.logInfo(
        'zim join room finish',
        tag: 'signaling',
        subTag: 'room',
      );

      assert(zimResult.roomInfo.baseInfo.roomID.isNotEmpty,
          'zimResult.roomInfo.baseInfo.roomID.isNotEmpty');

      return const ZegoSignalingPluginJoinRoomResult();
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'zim join room, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomLoginError,
              message: 'room id:$roomID',
              method: '_joinRoom',
            ),
          );

      return ZegoSignalingPluginJoinRoomResult(
        error: error,
      );
    });
  }

  /// leave room
  @override
  Future<ZegoSignalingPluginLeaveRoomResult> leaveRoom({
    required String roomID,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'leave room, room id:$roomID',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .leaveRoom(roomID)
        .then((value) => const ZegoSignalingPluginLeaveRoomResult())
        .catchError((error) {
      ZegoSignalingLoggerService.logError(
        'leave room, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomLogoutError,
              message:
                  'room id:$roomID, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'leaveRoom',
            ),
          );

      return ZegoSignalingPluginLeaveRoomResult(
        error: error,
      );
    });
  }

  /// update room properties
  @override
  Future<ZegoSignalingPluginRoomPropertiesOperationResult>
      updateRoomProperties({
    required String roomID,
    required Map<String, String> roomProperties,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'update room properties, room id:$roomID, properties:$roomProperties,'
      'isForce:$isForce, isDeleteAfterOwnerLeft:$isDeleteAfterOwnerLeft, isUpdateOwner:$isUpdateOwner, ',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .setRoomAttributes(
          roomProperties,
          roomID,
          ZIMRoomAttributesSetConfig()
            ..isForce = isForce
            ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
            ..isUpdateOwner = isUpdateOwner,
        )
        .then((zimResult) {
      return ZegoSignalingPluginRoomPropertiesOperationResult(
        errorKeys: zimResult.errorKeys,
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'update room properties, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomPropertyUpdateError,
              message:
                  'room id:$roomID, room properties:$roomProperties, is force:$isForce, is delete after owner left:$isDeleteAfterOwnerLeft, is update owner:$isUpdateOwner, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'updateRoomProperties',
            ),
          );

      return ZegoSignalingPluginRoomPropertiesOperationResult(
        error: error,
        errorKeys: roomProperties.keys.toList(),
      );
    });
  }

  /// delete room properties
  @override
  Future<ZegoSignalingPluginRoomPropertiesOperationResult>
      deleteRoomProperties({
    required String roomID,
    required List<String> keys,
    required bool isForce,
    bool showErrorLog = true,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'delete room properties, room id:$roomID, keys:$keys, isForce:$isForce',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .deleteRoomAttributes(
          keys,
          roomID,
          ZIMRoomAttributesDeleteConfig()..isForce = isForce,
        )
        .then((zimResult) {
      return ZegoSignalingPluginRoomPropertiesOperationResult(
        errorKeys: zimResult.errorKeys,
      );
    }).catchError((error) {
      if (showErrorLog) {
        ZegoSignalingLoggerService.logError(
          'delete room properties, error:${error.toString()}',
          tag: 'signaling',
          subTag: 'room',
        );

        ZegoSignalingPluginCore().errorStreamCtrl?.add(
              ZegoSignalingError(
                code: ZegoSignalingErrorCode.roomPropertyDeleteError,
                message:
                    'room id:$roomID, keys:$keys, is force:$isForce, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
                method: 'deleteRoomProperties',
              ),
            );
      }

      return ZegoSignalingPluginRoomPropertiesOperationResult(
        error: error,
        errorKeys: keys.toList(),
      );
    });
  }

  /// begin room properties batch operation
  @override
  void beginRoomPropertiesBatchOperation({
    required String roomID,
    bool isForce = false,
    bool isDeleteAfterOwnerLeft = false,
    bool isUpdateOwner = false,
  }) {
    ZegoSignalingLoggerService.logInfo(
      'begin room properties batch operation',
      tag: 'signaling',
      subTag: 'room',
    );

    ZIM.getInstance()!.beginRoomAttributesBatchOperation(
          roomID,
          ZIMRoomAttributesBatchOperationConfig()
            ..isForce = isForce
            ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft
            ..isUpdateOwner = isUpdateOwner,
        );
  }

  /// end room properties batch operation
  @override
  Future<ZegoSignalingPluginEndRoomBatchOperationResult>
      endRoomPropertiesBatchOperation({
    required String roomID,
  }) async {
    ZegoSignalingLoggerService.logInfo(
      'end room properties batch operation',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .endRoomAttributesBatchOperation(roomID)
        .then((value) => const ZegoSignalingPluginEndRoomBatchOperationResult())
        .catchError((error) {
      ZegoSignalingLoggerService.logError(
        'end room properties batch operation, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomPropertyEndBatchError,
              message:
                  'room id:$roomID, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'endRoomPropertiesBatchOperation',
            ),
          );

      return ZegoSignalingPluginEndRoomBatchOperationResult(
        error: error,
      );
    });
  }

  /// query room properties
  @override
  Future<ZegoSignalingPluginQueryRoomPropertiesResult> queryRoomProperties({
    required String roomID,
  }) {
    return ZIM
        .getInstance()!
        .queryRoomAllAttributes(roomID)
        .then((zimResult) => ZegoSignalingPluginQueryRoomPropertiesResult(
              properties: zimResult.roomAttributes,
            ))
        .catchError((error) {
      ZegoSignalingLoggerService.logError(
        'query room properties, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.roomPropertyQueryError,
              message:
                  'room id:$roomID, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'queryRoomProperties',
            ),
          );

      return ZegoSignalingPluginQueryRoomPropertiesResult(
        error: error,
        properties: const {},
      );
    });
  }

  /// query users in room attributes
  @override
  Future<ZegoSignalingPluginQueryUsersInRoomAttributesResult>
      queryUsersInRoomAttributes({
    required String roomID,
    int count = 100,
    String nextFlag = '',
  }) {
    return ZIM
        .getInstance()!
        .queryRoomMemberAttributesList(
          roomID,
          ZIMRoomMemberAttributesQueryConfig()
            ..count = count
            ..nextFlag = nextFlag,
        )
        .then((zimResult) {
      return ZegoSignalingPluginQueryUsersInRoomAttributesResult(
        nextFlag: zimResult.nextFlag,
        attributes: {
          for (var element in zimResult.infos)
            element.userID: element.attributes
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'query user in-room attributes, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.userInRoomPropertyQueryError,
              message:
                  'room id:$roomID, count:$count, next flag:$nextFlag, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'queryUsersInRoomAttributes',
            ),
          );

      return ZegoSignalingPluginQueryUsersInRoomAttributesResult(
        error: error,
        nextFlag: '',
        attributes: const {},
      );
    });
  }

  /// set users in room attributes
  @override
  Future<ZegoSignalingPluginSetUsersInRoomAttributesResult>
      setUsersInRoomAttributes({
    required String roomID,
    required List<String> userIDs,
    required Map<String, String> setAttributes,
    bool isDeleteAfterOwnerLeft = true,
  }) {
    ZegoSignalingLoggerService.logInfo(
      'set user in-room attributes, room id:$roomID, userIDs:$userIDs, '
      'attributes:$setAttributes, isDeleteAfterOwnerLeft:$isDeleteAfterOwnerLeft',
      tag: 'signaling',
      subTag: 'room',
    );

    return ZIM
        .getInstance()!
        .setRoomMembersAttributes(
            setAttributes,
            userIDs,
            roomID,
            ZIMRoomMemberAttributesSetConfig()
              ..isDeleteAfterOwnerLeft = isDeleteAfterOwnerLeft)
        .then((ZIMRoomMembersAttributesOperatedResult zimResult) {
      return ZegoSignalingPluginSetUsersInRoomAttributesResult(
        errorUserList: zimResult.errorUserList,
        errorKeys: {
          for (var element in zimResult.infos)
            element.attributesInfo.userID: element.errorKeys
        },
        attributes: {
          for (var element in zimResult.infos)
            element.attributesInfo.userID: element.attributesInfo.attributes
        },
      );
    }).catchError((error) {
      ZegoSignalingLoggerService.logError(
        'set user in-room attributes, error:${error.toString()}',
        tag: 'signaling',
        subTag: 'room',
      );

      ZegoSignalingPluginCore().errorStreamCtrl?.add(
            ZegoSignalingError(
              code: ZegoSignalingErrorCode.userInRoomPropertySetError,
              message:
                  'room id:$roomID, user ids:$userIDs, set attributes:$setAttributes, is delete after owner left:$isDeleteAfterOwnerLeft, exception:$error, ${ZegoSignalingErrorCode.zimErrorCodeDocumentTips}',
              method: 'setUsersInRoomAttributes',
            ),
          );

      return ZegoSignalingPluginSetUsersInRoomAttributesResult(
        error: error,
        errorUserList: userIDs,
        attributes: {},
        errorKeys: {},
      );
    });
  }
}

/// @nodoc
class ZegoSignalingPluginRoomEventImpl implements ZegoSignalingPluginRoomEvent {
  /// room properties updated event
  @override
  Stream<ZegoSignalingPluginRoomPropertiesUpdatedEvent>
      getRoomPropertiesUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .roomPropertiesUpdatedEvent
        .stream;
  }

  /// room properties batch updated event
  @override
  Stream<ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent>
      getRoomPropertiesBatchUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .roomPropertiesBatchUpdatedEvent
        .stream;
  }

  /// get room state
  @override
  ZegoSignalingPluginRoomState getRoomState() {
    return ZegoSignalingPluginRoomState
        .values[ZegoSignalingPluginCore().eventCenter.roomState.index];
  }

  /// room state changed event
  @override
  Stream<ZegoSignalingPluginRoomStateChangedEvent>
      getRoomStateChangedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomStateChangedEvent.stream;
  }

  /// users in-room attributes updated event
  @override
  Stream<ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent>
      getUsersInRoomAttributesUpdatedEventStream() {
    return ZegoSignalingPluginCore()
        .eventCenter
        .usersInRoomAttributesUpdatedEvent
        .stream;
  }

  /// room member joined event
  @override
  Stream<ZegoSignalingPluginRoomMemberJoinedEvent>
      getRoomMemberJoinedEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomMemberJoinedEvent.stream;
  }

  /// room member left event
  @override
  Stream<ZegoSignalingPluginRoomMemberLeftEvent>
      getRoomMemberLeftEventStream() {
    return ZegoSignalingPluginCore().eventCenter.roomMemberLeftEvent.stream;
  }
}
